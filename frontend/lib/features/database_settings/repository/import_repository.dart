import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:flutter/services.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/meters/model/entry_dto.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/room/model/room_dto.dart';
import 'package:openmeter/features/tags/model/tag_dto.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/database/local_database.dart';
import '../../meters/service/meter_image_service.dart';

class ImportRepository {
  final LocalDatabase _database;

  final MeterImageService _imageService = MeterImageService();

  ImportRepository(this._database);

  _handleImportZip(String path) async {
    await _imageService.createDirectory();

    final inputStream = InputFileStream(path);
    final zipData = ZipDecoder().decodeStream(inputStream);

    final saveImagePath = await _imageService.getDir();

    for (var file in zipData.files) {
      if (file.isFile) {
        final fileName = file.name;

        if (fileName.endsWith('.jpg')) {
          final fileNameArray = fileName.split('/');

          final outputStream =
              OutputFileStream('${saveImagePath!.path}/${fileNameArray[1]}');

          file.writeContent(outputStream);

          outputStream.close();
        }
        if (fileName.endsWith('.json')) {
          final cacheDir = await getApplicationCacheDirectory();

          final outputStream = OutputFileStream('${cacheDir.path}/meter.json');

          file.writeContent(outputStream);

          outputStream.close();
        }
      }
    }
  }

  Future<List<RoomDto>> _importRooms(List roomJson) async {
    final List<RoomDto> rooms =
        roomJson.map((e) => RoomDto.fromJson(e)).toList();

    await _database.batch(
      (batch) {
        for (RoomDto room in rooms) {
          batch.insert(_database.room, room.toCompanion());
        }
      },
    );

    return rooms;
  }

  Future<void> _importTags(List tagsJson) async {
    List<TagDto> finalTags = tagsJson.map((e) => TagDto.fromJson(e)).toList();

    await _database.batch(
      (batch) {
        for (TagDto tag in finalTags) {
          batch.insert(_database.tags, tag.toCompanion());
        }
      },
    );
  }

  Future<void> _importContracts(List contractsJson) async {
    List<ContractDto> contracts = contractsJson
        .map(
          (e) => ContractDto.fromJson(e),
        )
        .toList();

    for (ContractDto contract in contracts) {
      if (contract.provider != null) {
        int providerId = await _database.contractDao
            .createProvider(contract.provider!.toCompanion());

        contract.provider!.id = providerId;
      }

      contract.id =
          await _database.contractDao.createContract(contract.toCompanion());

      if (contract.compareCosts != null) {
        final compareCosts = contract.compareCosts!;
        compareCosts.parentId = contract.id;

        await _database.costCompareDao
            .createCompareCost(compareCosts.toCostCompareCompanion());
      }
    }
  }

  Future _importMeters(List meterJson, List<RoomDto> rooms) async {
    for (dynamic json in meterJson) {
      MeterDto meter = MeterDto.fromJson(json);

      final entriesDto =
          (json['entries'] as List<dynamic>).map((e) => EntryDto.fromJson(e));

      List<String> tags =
          (json['tags'] as List<dynamic>).map((e) => e.toString()).toList();

      RoomDto? room;

      if (json['room'] != null) {
        room = rooms.firstWhereOrNull(
          (element) => element.uuid == json['room'],
        );
      }

      meter.id = await _database.meterDao.createMeter(meter.toMeterCompanion());

      if (room != null) {
        await _database.roomDao.createMeterInRoom(MeterInRoomCompanion(
          roomId: Value(room.uuid),
          meterId: Value(meter.id!),
        ));
      }

      if (tags.isNotEmpty) {
        for (String tag in tags) {
          await _database.batch(
            (batch) {
              _database.tagsDao.createMeterWithTag(MeterWithTagsCompanion(
                  meterId: Value(meter.id!), tagId: Value(tag)));
            },
          );
        }
      }

      if (entriesDto.isNotEmpty) {
        final entries = entriesDto.map(
          (e) {
            e.meterId = meter.id;

            return e.toCompanion();
          },
        );

        await _database.batch(
          (batch) {
            batch.insertAll(_database.entries, entries);
          },
        );
      }
    }
  }

  Future<bool> importFromJson({required String path}) async {
    File? file;

    if (path.endsWith('.zip')) {
      await _handleImportZip(path);

      final cacheDir = await getApplicationCacheDirectory();

      file = File('${cacheDir.path}/meter.json');
    } else {
      file = File(path);
    }

    if (!file.existsSync()) {
      return false;
    }

    Map<String, dynamic> json = jsonDecode(file.readAsStringSync());

    await _database.transaction(
      () async {
        final rooms = await _importRooms(json['rooms']);
        await _importTags(json['tags']);
        await _importContracts(json['contracts']);
        await _importMeters(json['meters'], rooms);
      },
    );

    return true;
  }
}

Future<bool> runImportAsIsolate(
    {required String path,
    required LocalDatabase db,
    required RootIsolateToken rootToken}) async {
  final connection = await db.serializableConnection();

  return await Isolate.run(
    () async {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootToken);

      final db = LocalDatabase(await connection.connect());

      final repo = ImportRepository(db);

      final result = await repo.importFromJson(path: path);

      db.close();

      return result;
    },
    debugName: 'Export Database as JSON',
  );
}
