import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/database/daos/entry_dao.dart';
import 'package:openmeter/core/database/daos/meter_dao.dart';
import 'package:openmeter/core/database/daos/room_dao.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/core/database/model/meter_with_room.dart';
import 'package:openmeter/core/database/model/room_model.dart';
import 'package:openmeter/features/meters/model/entry_dto.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/room/model/details_room_model.dart';
import 'package:openmeter/features/room/model/meter_room_dto.dart';
import 'package:openmeter/features/room/model/room_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'room_repository.g.dart';

class RoomRepository {
  final RoomDao _roomDao;
  final EntryDao _entryDao;
  final MeterDao _meterDao;

  RoomRepository(this._roomDao, this._entryDao, this._meterDao);

  Future<List<RoomDto>> fetchRooms() async {
    final List<RoomModel> data = await _roomDao.getAllRoomsModel();

    final Map<int, Map<String, dynamic>> grouped = {};

    for (RoomModel model in data) {
      final room = model.room;

      if (!grouped.containsKey(room.id)) {
        grouped[room.id] = {'room': room, 'meter': <MeterDto>[]};
      }

      if (model.meter != null) {
        grouped[room.id]!['meter'].add(MeterDto.fromData(model.meter!, false));
      }
    }

    final List<RoomDto> result = [];

    for (Map<String, dynamic> data in grouped.values) {
      RoomDto room = RoomDto.fromData(data['room']);
      room.meters = data['meter'];

      result.add(room);
    }

    return result;
  }

  Future<RoomDto> createRoom(RoomCompanion roomCompanion) async {
    final int id = await _roomDao.createRoom(roomCompanion);

    final RoomDto room = RoomDto.fromCompanion(roomCompanion);

    room.id = id;

    return room;
  }

  Future deleteRoom(RoomDto room) async {
    await _roomDao.deleteRoom(room.uuid);
  }

  Future<int> deleteMeterFromRoom(int meterId) async {
    return await _roomDao.deleteMeter(meterId);
  }

  Future updateRoom(RoomDto room) async {
    return await _roomDao.updateRoom(room.toData());
  }

  Future<DetailsRoomDto> fetchDetailsRoom(int roomId) async {
    final roomData = await _roomDao.findById(roomId);

    final roomDto = RoomDto.fromData(roomData);

    final meters = await _roomDao.getMeterInRooms(roomDto.uuid);

    for (MeterDto meter in meters) {
      final entryData = await _entryDao.getNewestEntry(meter.id!);

      if (entryData == null) {
        continue;
      }

      meter.lastEntry = EntryDto.fromData(entryData);
      meter.hasEntry = true;
    }

    roomDto.meters = meters;

    return DetailsRoomDto(roomDto, meters);
  }

  Future<int> removeMeterFromRoom(MeterDto meter) async {
    return await _roomDao.deleteMeter(meter.id!);
  }

  Future<List<MeterRoomDto>> fetchAllMeterWithRoom({int? roomId}) async {
    final List<MeterWithRoom> data = await _meterDao.getAllMeterWithRooms();

    final List<MeterRoomDto> result = [];

    for (MeterWithRoom p in data) {
      RoomDto? room;
      bool isInCurrentRoom = false;
      bool isInARoom = false;

      if (p.room != null) {
        final RoomData roomData = p.room!;
        if (roomData.id == roomId) {
          isInCurrentRoom = true;
        }

        if (roomData.id != roomId) {
          isInARoom = true;
        }

        room = RoomDto.fromData(roomData);
      }

      final MeterDto meter = MeterDto.fromData(p.meter, false);

      result.add(MeterRoomDto(room, meter, isInCurrentRoom, isInARoom));
    }

    return result;
  }

  Future<void> saveAllMetersWithRoom({required String roomId, required List<MeterDto> meters}) async {
    for (MeterDto meter in meters) {
      final data = MeterInRoomCompanion(roomId: Value(roomId), meterId: Value(meter.id!));

      await _roomDao.createMeterInRoom(data);
    }
  }

  Future<void> updateAllMetersWithRoom({required String roomId, required List<MeterDto> meters}) async {
    for (MeterDto meter in meters) {
      final data = MeterInRoomCompanion(roomId: Value(roomId), meterId: Value(meter.id!));

      await _roomDao.updateMeterInRoom(data);
    }
  }

  Future<RoomDto?> findByMeterId(int meterId) async {
    final data = await _roomDao.findByMeterId(meterId);

    return data != null ? RoomDto.fromData(data) : null;
  }

  Future updateAssoziation(RoomDto room, MeterDto meter) async {
    final inRoom = await _roomDao.findByMeterId(meter.id!);

    final MeterInRoomCompanion companion = MeterInRoomCompanion(meterId: Value(meter.id!), roomId: Value(room.uuid));

    if (inRoom == null) {
      await _roomDao.createMeterInRoom(companion);

      return;
    }

    await _roomDao.updateMeterInRoom(companion);
  }

  Future<int> getTableLength() async {
    return await _roomDao.getTableLength() ?? 0;
  }
}

@riverpod
RoomRepository roomRepository(Ref ref) {
  final db = ref.watch(localDbProvider);

  return RoomRepository(db.roomDao, db.entryDao, db.meterDao);
}
