import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/database/daos/entry_dao.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/core/model/entry_dto.dart';
import 'package:openmeter/features/meters/helper/entry_helper.dart';
import 'package:openmeter/features/meters/service/meter_image_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entry_repository.g.dart';

class EntryRepository {
  final EntryDao _entryDao;
  final EntryHelper _entryHelper = EntryHelper();
  final MeterImageService _imageService = MeterImageService();

  EntryRepository(this._entryDao);

  Future<List<EntryDto>> fetchEntriesForMeter(int meterId) async {
    final entriesData = await _entryDao.getAllEntries(meterId);

    List<EntryDto> entries = entriesData
        .map(
          (e) => EntryDto.fromData(e),
        )
        .toList();

    return entries;
  }

  Future<int> createEntry(EntryDto entry) async {
    return await _entryDao.createEntry(entry.toCompanion());
  }

  Future<EntryDto?> getNewestEntryForMeter(int meterId) async {
    final data = await _entryDao.getNewestEntry(meterId);

    if (data == null) {
      return null;
    }

    return EntryDto.fromData(data);
  }

  Future<EntryDto> updateNextEntry(
      {required EntryDto nextEntry, required EntryDto prevEntry}) async {
    if (!nextEntry.isReset) {
      int usage = nextEntry.count - prevEntry.count;
      int days = nextEntry.date.difference(prevEntry.date).inDays;

      EntriesCompanion newEntry =
          EntriesCompanion(usage: Value(usage), days: Value(days));

      await _entryDao.updateEntry(nextEntry.id!, newEntry);

      nextEntry.usage = usage;
      nextEntry.days = days;
    }

    return nextEntry;
  }

  Future<List<EntryDto>> addNewEntry(
      List<EntryDto> currentEntries, EntryDto newEntry) async {
    EntryDto? lastEntry = currentEntries.firstOrNull;

    String lastCount = lastEntry != null ? lastEntry.count.toString() : 'none';
    DateTime? oldDate = lastEntry?.date;

    if (lastEntry != null && newEntry.date.isBefore(lastEntry.date)) {
      final EntryDto? prevEntry = currentEntries.firstWhereOrNull(
        (element) => element.date.isBefore(newEntry.date),
      );

      String usageCount = 'none';
      DateTime date = newEntry.date;

      if (prevEntry != null) {
        usageCount = prevEntry.count.toString();
        date = prevEntry.date;
      }

      newEntry.usage = newEntry.isReset
          ? -1
          : _entryHelper.calcUsage(usageCount, newEntry.count);

      newEntry.days =
          newEntry.isReset ? -1 : _entryHelper.calcDays(newEntry.date, date);

      newEntry.id = await _entryDao.createEntry(newEntry.toCompanion());

      print('newExntry.id = ${newEntry.id}');
      int index = currentEntries.indexWhere(
        (element) => element.date.isBefore(newEntry.date),
      );

      currentEntries.insert(index, newEntry);

      EntryDto? nextEntry = currentEntries.elementAtOrNull(index - 1);

      if (nextEntry != null) {
        nextEntry =
            await updateNextEntry(nextEntry: nextEntry, prevEntry: newEntry);

        currentEntries[currentEntries.indexWhere(
          (element) => element.id == nextEntry!.id,
        )] = nextEntry;
      }

      return currentEntries;
    }

    newEntry.usage = newEntry.isReset
        ? -1
        : _entryHelper.calcUsage(lastCount, newEntry.count);

    newEntry.days = newEntry.isReset || oldDate == null
        ? -1
        : _entryHelper.calcDays(newEntry.date, oldDate);

    await _entryDao.createEntry(newEntry.toCompanion());

    currentEntries.insert(0, newEntry);

    return currentEntries;
  }

  Future<void> deleteEntry(EntryDto entry) async {
    if (entry.imagePath != null) {
      await _imageService.deleteImage(entry.imagePath!);
    }

    await _entryDao.deleteEntry(entry.id!);
  }

  Future<int> updateEntry(EntryDto entry) async {
    return await _entryDao.updateEntry(entry.id!, entry.toCompanion());
  }
}

@riverpod
EntryRepository entryRepository(Ref ref) {
  final db = ref.watch(localDbProvider);

  return EntryRepository(db.entryDao);
}
