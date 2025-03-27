import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/database/daos/meter_dao.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/core/database/model/meter_with_room.dart';
import 'package:openmeter/core/exception/null_value.dart';
import 'package:openmeter/features/meters/helper/entry_helper.dart';
import 'package:openmeter/features/meters/model/details_meter_model.dart';
import 'package:openmeter/features/meters/model/entry_dto.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/meters/repository/entry_repository.dart';
import 'package:openmeter/features/room/model/room_dto.dart';
import 'package:openmeter/features/room/repository/room_repository.dart';
import 'package:openmeter/features/tags/model/tag_dto.dart';
import 'package:openmeter/features/tags/repository/tag_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meter_repository.g.dart';

class MeterRepository {
  final MeterDao _meterDao;
  final EntryRepository _entryRepository;
  final RoomRepository _roomRepository;
  final TagRepository _tagRepository;

  final EntryHelper _entryHelper = EntryHelper();

  MeterRepository(this._meterDao, this._entryRepository, this._roomRepository,
      this._tagRepository);

  Future<List<MeterDto>> fetchMeters({bool? isArchived}) async {
    final data = await _meterDao.getAllMeterWithRooms(isArchived: isArchived);

    List<MeterDto> result = [];

    for (MeterWithRoom m in data) {
      final EntryDto? entry =
          await _entryRepository.getNewestEntryForMeter(m.meter.id);

      final meterDto = MeterDto.fromData(m.meter, entry != null);
      meterDto.lastEntry = entry;
      meterDto.room = m.room != null ? RoomDto.fromData(m.room!) : null;

      result.add(meterDto);
    }

    return result;
  }

  Future deleteSingleMeter(MeterDto meter) async {
    if (meter.id == null) {
      throw NullValueException();
    }

    if (meter.room != null) {
      await _roomRepository.deleteMeterFromRoom(meter.id!);
    }

    await _meterDao.deleteMeter(meter.id!);
  }

  Future<MeterDto> resetMeter(MeterDto meter) async {
    final EntryDto entry = EntryDto(
      count: 0,
      usage: -1,
      days: -1,
      isReset: true,
      transmittedToProvider: false,
      date: DateTime.now(),
      meterId: meter.id,
    );

    final int entryId = await _entryRepository.createEntry(entry);

    entry.id = entryId;

    meter.lastEntry = entry;

    return meter;
  }

  Future<MeterDto> createMeter(
      {required MeterDto meter,
      int? currentCount,
      RoomDto? room,
      required List<String> tags}) async {
    meter.id = await _meterDao.createMeter(meter.toMeterCompanion());

    if (currentCount != null) {
      final EntryDto entry = EntryDto(
        count: currentCount,
        date: DateTime.now(),
        meterId: meter.id,
      );
      entry.id = await _entryRepository.createEntry(entry);

      meter.lastEntry = entry;
    }

    if (room != null) {
      meter.room = room;

      await _roomRepository
          .saveAllMetersWithRoom(roomId: room.uuid, meters: [meter]);
    }

    if (tags.isNotEmpty) {
      meter.tags = tags;

      for (String tag in tags) {
        await _tagRepository.createMeterWithTag(meter.id!, tag);
      }
    }

    return meter;
  }

  Future<void> saveMeterArchiveState(MeterDto meter) async {
    await _meterDao.updateArchived(meter.id!, meter.isArchived);
  }

  Future<DetailsMeterModel> fetchDetailsMeter(
      int meterId, bool predictCount) async {
    final MeterData meterData = await _meterDao.getSingleMeter(meterId);
    final MeterDto meter = MeterDto.fromData(meterData, false);

    List<EntryDto> entries =
        await _entryRepository.fetchEntriesForMeter(meterId);

    meter.hasEntry = entries.isNotEmpty;
    meter.lastEntry = entries.firstOrNull;

    final RoomDto? room = await _roomRepository.findByMeterId(meterId);

    if (room != null) {
      meter.room = room;
    }

    String predictedCount = '';

    if (entries.length > 3 && predictCount) {
      predictedCount = _entryHelper.predictCount(entries.first, entries.last);
    }

    List<TagDto> tags = await _tagRepository.getTagsForMeter(meterId);
    meter.tags = tags
        .map(
          (e) => e.uuid!,
        )
        .toList();

    return DetailsMeterModel(
        meter: meter,
        entries: entries,
        room: room,
        predictCount: predictedCount);
  }

  Future<MeterDto> updateMeter(
      {required MeterDto oldMeter,
      RoomDto? newRoom,
      required List<String> tags,
      required MeterDto newMeter}) async {
    if (newRoom == null && oldMeter.room != null) {
      await _roomRepository.removeMeterFromRoom(oldMeter);
    }

    if (newRoom != null) {
      await _roomRepository.updateAssoziation(newRoom, oldMeter);
    }

    if (tags.isEmpty && oldMeter.tags.isNotEmpty) {
      for (String tag in oldMeter.tags) {
        await _tagRepository.removeAssoziation(oldMeter, tag);
      }
    }

    if (tags.isNotEmpty) {
      for (String tag in tags) {
        if (oldMeter.tags.contains(tag)) {
          await _tagRepository.removeAssoziation(oldMeter, tag);
          continue;
        }

        await _tagRepository.createMeterWithTag(oldMeter.id!, tag);
      }
    }

    newMeter.tags = tags + oldMeter.tags;
    newMeter.id = oldMeter.id;
    newMeter.lastEntry = oldMeter.lastEntry;
    newMeter.hasEntry = oldMeter.hasEntry;
    newMeter.isArchived = oldMeter.isArchived;
    newMeter.room = newRoom;

    await _meterDao.updateMeter(newMeter.toMeterData());

    return newMeter;
  }

  Future<int> getTableLength() async {
    return await _meterDao.getTableLength() ?? 0;
  }

  Future<int> countMeters(bool isArchived) async {
    return await _meterDao.countMeters(isArchived);
  }
}

@riverpod
MeterRepository meterRepository(Ref ref) {
  final db = ref.watch(localDbProvider);

  return MeterRepository(db.meterDao, ref.watch(entryRepositoryProvider),
      ref.watch(roomRepositoryProvider), ref.watch(tagRepositoryProvider));
}
