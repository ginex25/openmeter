import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/contract/repository/contract_repository.dart';
import 'package:openmeter/features/database_settings/model/stats_model.dart';
import 'package:openmeter/features/meters/repository/entry_repository.dart';
import 'package:openmeter/features/meters/repository/meter_repository.dart';
import 'package:openmeter/features/meters/service/meter_image_helper.dart';
import 'package:openmeter/features/room/repository/room_repository.dart';
import 'package:openmeter/features/tags/repository/tag_repository.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stats_repository.g.dart';

class DatabaseStatsRepository {
  final MeterRepository _meterRepository;
  final EntryRepository _entryRepository;
  final ContractRepository _contractRepository;
  final RoomRepository _roomRepository;
  final TagRepository _tagRepository;
  final MeterImageService _imageService = MeterImageService();

  DatabaseStatsRepository(this._meterRepository, this._entryRepository,
      this._contractRepository, this._roomRepository, this._tagRepository);

  String _formatSize(int size) {
    if (size < 1024 * 1024) {
      String sizeString = (size / 1024).toStringAsFixed(2);

      if (sizeString.endsWith('.00')) {
        sizeString = sizeString.substring(0, sizeString.indexOf('.'));
      }

      return '$sizeString KB';
    } else if (size < 1024 * 1024 * 1024) {
      String sizeString = (size / 1024 / 1024).toStringAsFixed(2);

      if (sizeString.endsWith('.00')) {
        sizeString = sizeString.substring(0, sizeString.indexOf('.'));
      }

      return '$sizeString MB';
    } else {
      return '0 KB';
    }
  }

  Future<({int fullSize, int databaseSize})> getFullSize(int imageSize) async {
    final directory = await getApplicationDocumentsDirectory();
    String dbPath = p.join(directory.path, 'meter.db');

    final file = File(dbPath);

    int databaseSize = await file.length();

    int fullSize = databaseSize + imageSize;

    return (fullSize: fullSize, databaseSize: databaseSize);
  }

  Future<DatabaseStatsModel> fetchDatabaseStats() async {
    final int sumMeters = await _meterRepository.getTableLength();
    final int sumEntries = await _entryRepository.getTableLength();
    final int sumContracts = await _contractRepository.getTableLength();
    final int sumRooms = await _roomRepository.getTableLength();
    final int sumTags = await _tagRepository.getTableLength();

    await _imageService.createDirectory();
    final int sumImages = await _imageService.getFolderLength();
    final int imageSize = await _imageService.getFolderSize();

    final fullSizes = await getFullSize(imageSize);

    int totalItemCounts =
        sumMeters + sumEntries + sumContracts + sumRooms + sumTags + sumImages;

    List<double> itemValues = [];

    double percentMeter = sumMeters / totalItemCounts;
    double percentEntries = sumEntries / totalItemCounts;
    double percentRooms = sumRooms / totalItemCounts;
    double percentTags = sumTags / totalItemCounts;
    double percentContracts = sumContracts / totalItemCounts;
    double percentImages = sumImages / totalItemCounts;

    itemValues.addAll([
      percentMeter,
      percentEntries,
      percentRooms,
      percentContracts,
      percentTags,
      percentImages
    ]);

    return DatabaseStatsModel(
        _formatSize(fullSizes.databaseSize),
        _formatSize(imageSize),
        _formatSize(fullSizes.fullSize),
        totalItemCounts,
        itemValues,
        sumMeters,
        sumRooms,
        sumContracts,
        sumEntries,
        sumTags,
        sumImages);
  }
}

@riverpod
DatabaseStatsRepository databaseStatsRepository(Ref ref) {
  return DatabaseStatsRepository(
      ref.watch(meterRepositoryProvider),
      ref.watch(entryRepositoryProvider),
      ref.watch(contractRepositoryProvider),
      ref.watch(roomRepositoryProvider),
      ref.watch(tagRepositoryProvider));
}
