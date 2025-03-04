import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/database/daos/meter_dao.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/core/exception/null_value.dart';
import 'package:openmeter/core/model/entry_dto.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/core/model/meter_with_room.dart';
import 'package:openmeter/core/model/room_dto.dart';
import 'package:openmeter/features/room/repository/room_repository.dart';
import 'package:openmeter/features/tags/repository/tag_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/daos/entry_dao.dart';

part 'meter_repository.g.dart';

class MeterRepository {
  final MeterDao _meterDao;
  final EntryDao _entryDao;
  final RoomRepository _roomRepository;
  final TagRepository _tagRepository;

  MeterRepository(this._meterDao, this._entryDao, this._roomRepository,
      this._tagRepository);

  Future<List<MeterDto>> fetchMeters() async {
    final data = await _meterDao.getAllMeterWithRooms(isArchived: false);

    List<MeterDto> result = [];

    for (MeterWithRoom m in data) {
      final Entry? entry = await _entryDao.getNewestEntry(m.meter.id);

      final meterDto = MeterDto.fromData(m.meter, entry != null);
      meterDto.lastEntry = entry != null ? EntryDto.fromData(entry) : null;
      meterDto.room = m.room?.name ?? '';

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
    final EntriesCompanion entry = EntriesCompanion(
      meter: Value(meter.id!),
      date: Value(DateTime.now()),
      count: const Value(0),
      usage: const Value(-1),
      days: const Value(-1),
      isReset: const Value(true),
      transmittedToProvider: const Value(false),
    );

    final int entryId = await _entryDao.createEntry(entry);

    final EntryDto lastEntry = EntryDto.fromEntriesCompanion(entry);

    lastEntry.id = entryId;

    meter.lastEntry = lastEntry;

    return meter;
  }

  Future<MeterDto> createMeter(
      {required MeterDto meter,
      required int currentCount,
      RoomDto? room,
      required List<String> tags}) async {
    meter.id = await _meterDao.createMeter(meter.toMeterCompanion());

    final EntryDto entry = EntryDto(
      count: currentCount,
      date: DateTime.now(),
      meterId: meter.id,
    );

    entry.id = await _entryDao.createEntry(entry.toCompanion());

    meter.lastEntry = entry;

    if (room != null) {
      meter.room = room.name;

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
}

@riverpod
MeterRepository meterRepository(Ref ref) {
  final db = ref.watch(localDbProvider);

  return MeterRepository(db.meterDao, db.entryDao,
      ref.watch(roomRepositoryProvider), ref.watch(tagRepositoryProvider));
}
