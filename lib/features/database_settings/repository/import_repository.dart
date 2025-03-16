import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/model/entry_dto.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/core/model/room_dto.dart';
import 'package:openmeter/core/model/tag_dto.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/repository/compare_cost_repository.dart';
import 'package:openmeter/features/contract/repository/provider_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../contract/repository/contract_repository.dart';
import '../../meters/repository/entry_repository.dart';
import '../../meters/repository/meter_repository.dart';
import '../../meters/service/meter_image_service.dart';
import '../../room/repository/room_repository.dart';
import '../../tags/repository/tag_repository.dart';

part 'import_repository.g.dart';

class ImportRepository {
  final MeterRepository _meterRepository;
  final EntryRepository _entryRepository;
  final ContractRepository _contractRepository;
  final RoomRepository _roomRepository;
  final TagRepository _tagRepository;
  final ProviderRepository _providerRepository;
  final CompareCostRepository _compareCostRepository;
  final MeterImageService _imageService = MeterImageService();

  ImportRepository(
      this._meterRepository,
      this._entryRepository,
      this._contractRepository,
      this._roomRepository,
      this._tagRepository,
      this._providerRepository,
      this._compareCostRepository);

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
    List<RoomDto> rooms = roomJson.map((e) => RoomDto.fromJson(e)).toList();

    for (RoomDto room in rooms) {
      room = await _roomRepository.createRoom(room.toCompanion());
    }

    return rooms;
  }

  Future<void> _importTags(List tagsJson) async {
    List<TagDto> finalTags = tagsJson.map((e) => TagDto.fromJson(e)).toList();

    for (TagDto tag in finalTags) {
      await _tagRepository.createTag(tag);
    }
  }

  Future<void> _importContracts(List contractsJson) async {
    List<ContractDto> contracts = contractsJson
        .map(
          (e) => ContractDto.fromJson(e),
        )
        .toList();

    for (ContractDto contract in contracts) {
      if (contract.provider != null) {
        contract.provider =
            await _providerRepository.createProvider(contract.provider!, null);
      }

      contract =
          await _contractRepository.createContract(contract.toCompanion());

      if (contract.compareCosts != null) {
        final compareCosts = contract.compareCosts!;
        compareCosts.parentId = contract.id;

        await _compareCostRepository.createCompareCost(compareCosts);
      }
    }
  }

  Future _importMeters(List meterJson, List<RoomDto> rooms) async {
    for (dynamic json in meterJson) {
      MeterDto meter = MeterDto.fromJson(json);

      List entriesDto =
          json['entries'].map((e) => EntryDto.fromJson(e)).toList();

      List<String> tags =
          (json['tags'] as List<dynamic>).map((e) => e.toString()).toList();

      RoomDto? room;

      if (json['room'] != null) {
        room = rooms.firstWhereOrNull(
          (element) => element.uuid == json['room'],
        );
      }

      meter = await _meterRepository.createMeter(
          meter: meter, tags: tags, room: room);

      for (EntryDto entry in entriesDto) {
        entry.meterId = meter.id;
        await _entryRepository.createEntry(entry);
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

    final rooms = await _importRooms(json['rooms']);
    await _importTags(json['tags']);
    await _importContracts(json['contracts']);
    await _importMeters(json['meters'], rooms);

    return true;
  }
}

@riverpod
ImportRepository importRepository(Ref ref) {
  return ImportRepository(
    ref.watch(meterRepositoryProvider),
    ref.watch(entryRepositoryProvider),
    ref.watch(contractRepositoryProvider),
    ref.watch(roomRepositoryProvider),
    ref.watch(tagRepositoryProvider),
    ref.watch(providerRepositoryProvider),
    ref.watch(compareCostRepositoryProvider),
  );
}
