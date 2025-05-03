import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:drift/isolate.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/core/exception/null_value.dart';
import 'package:openmeter/features/contract/model/contract_dto.dart';
import 'package:openmeter/features/contract/repository/contract_repository.dart';
import 'package:openmeter/features/database_settings/helper/file_helper.dart';
import 'package:openmeter/features/meters/model/entry_dto.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/meters/repository/entry_repository.dart';
import 'package:openmeter/features/meters/repository/meter_repository.dart';
import 'package:openmeter/features/meters/service/meter_image_service.dart';
import 'package:openmeter/features/room/model/room_dto.dart';
import 'package:openmeter/features/room/repository/room_repository.dart';
import 'package:openmeter/features/tags/model/tag_dto.dart';
import 'package:openmeter/shared/constant/datetime_formats.dart';
import 'package:openmeter/shared/constant/log.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../tags/repository/tag_repository.dart';

class ExportRepository {
  final MeterRepository _meterRepository;
  final EntryRepository _entryRepository;
  final ContractRepository _contractRepository;
  final RoomRepository _roomRepository;
  final TagRepository _tagRepository;
  final MeterImageService _imageService = MeterImageService();
  final FileHelper _fileHelper = FileHelper();

  List<MeterDto> _meters = [];
  List<RoomDto> _rooms = [];
  List<ContractDto> _contracts = [];
  final Map<int, List<EntryDto>> _entries = {};
  List<TagDto> _tags = [];

  ExportRepository(this._meterRepository, this._entryRepository,
      this._contractRepository, this._roomRepository, this._tagRepository);

  Future<void> _getData() async {
    _meters = await _meterRepository.fetchMeters();
    _rooms = await _roomRepository.fetchRooms();
    _contracts = await _contractRepository.fetchContracts();
    _tags = await _tagRepository.fetchAllTags();

    for (MeterDto meter in _meters) {
      if (meter.id == null) {
        throw NullValueException('meter id should not be null');
      }

      List<EntryDto> entries =
          await _entryRepository.fetchEntriesForMeter(meter.id!);

      _entries.addAll({meter.id!: entries});

      List<TagDto> tags = await _tagRepository.getTagsForMeter(meter.id!);
      meter.tags = tags
          .map(
            (e) => e.uuid!,
          )
          .toList();
    }
  }

  String _convertToJson() {
    List<Map<String, dynamic>> jsonRoomList =
        _rooms.map((e) => e.toJson()).toList();
    List<Map<String, dynamic>> jsonContracts =
        _contracts.map((e) => e.toJson()).toList();
    List<Map<String, dynamic>> jsonTags = _tags.map((e) => e.toJson()).toList();
    List<Map<String, dynamic>> finalMeter = [];

    for (MeterDto meter in _meters) {
      List<EntryDto>? meterEntries = _entries[meter.id];

      finalMeter.add(meter.toJson(meterEntries ?? []));
    }

    Map<String, List> result = {
      'tags': jsonTags,
      'rooms': jsonRoomList,
      'meters': finalMeter,
      'contracts': jsonContracts,
    };

    return jsonEncode(result);
  }

  Future _handleExportImages(
    File dbFile,
    String fileName,
    String exportPath,
  ) async {
    try {
      final encoder = ZipFileEncoder();

      final newPath = p.join(exportPath, '${fileName.split('.')[0]}.zip');

      encoder.create(newPath);
      await encoder.addFile(dbFile);

      final dir = await _imageService.getDir();

      await encoder.addDirectory(dir!);

      encoder.close();

      dbFile.deleteSync();

      log('Successfully export db as zip file!',
          name: LogNames.databaseExportImport);
    } catch (e) {
      log('Error while export db as zip file: $e',
          name: LogNames.databaseExportImport);
    }
  }

  Future<bool> _exportAsJson(
      {required String path,
      bool clearBackupFiles = false,
      bool isAutoBackup = false,
      String cacheDir = ''}) async {
    try {
      await _getData();

      String jsonResult = _convertToJson();

      String fileName = 'meter.json';
      String newPath = p.join(path, fileName);

      if (isAutoBackup) {
        DateTime date = DateTime.now();
        String formattedDate =
            DateFormat(DateTimeFormats.timestamp24h).format(date);

        fileName = 'meter_$formattedDate.json';

        newPath = p.join(path, fileName);

        if (clearBackupFiles) {
          await _fileHelper.clearLastBackupFiles(path);
        }
      }

      final hasImages = await _imageService.imagesExists();

      if (hasImages && cacheDir.isNotEmpty) {
        newPath = p.join(cacheDir, fileName);
      }

      File file = File(newPath);

      if (await file.exists()) {
        file.deleteSync();
      }

      file.writeAsStringSync(jsonResult, flush: true, mode: FileMode.write);

      if (hasImages) {
        await _handleExportImages(file, fileName, path);
      }

      return true;
    } on PlatformException catch (e) {
      log('Error Unsupported operation: ${e.toString()}',
          name: 'Export as JSON');

      return false;
    } catch (e) {
      log('Error: ${e.toString()}', name: 'Export as JSON');
      return false;
    }
  }

  Future<bool> runExport({
    required String path,
    bool clearBackupFiles = false,
    bool isAutoBackup = false,
  }) async {
    final cacheDir = await getApplicationCacheDirectory();
    await _imageService.createDirectory();

    log('export as autobackup: $isAutoBackup',
        name: LogNames.databaseExportImport);

    return await _exportAsJson(
        path: path,
        cacheDir: cacheDir.path,
        isAutoBackup: isAutoBackup,
        clearBackupFiles: clearBackupFiles);
  }
}

Future<bool> runExportAsIsolate({
  required String path,
  bool clearBackupFiles = false,
  bool isAutoBackup = false,
  required LocalDatabase db,
  required RootIsolateToken rootToken,
  required SharedPreferencesWithCache prefs,
}) async {
  final connection = await db.serializableConnection();

  return await Isolate.run(
    () async {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootToken);

      final db = LocalDatabase(await connection.connect());

      final TagRepository tagRepository = TagRepository(db.tagsDao, prefs);
      final RoomRepository roomRepository =
          RoomRepository(db.roomDao, db.entryDao, db.meterDao);
      final EntryRepository entryRepository = EntryRepository(db.entryDao);
      final ContractRepository contractRepository =
          ContractRepository(db.contractDao);
      final MeterRepository meterRepository = MeterRepository(
          db.meterDao, entryRepository, roomRepository, tagRepository);

      final repo = ExportRepository(
        meterRepository,
        entryRepository,
        contractRepository,
        roomRepository,
        tagRepository,
      );

      return await repo.runExport(
          path: path,
          clearBackupFiles: clearBackupFiles,
          isAutoBackup: isAutoBackup);
    },
    debugName: 'Export Database as JSON',
  );
}
