import 'package:drift/drift.dart';

import 'meter.dart';

@TableIndex(name: 'idx_room_id', columns: {#id})
@TableIndex(name: 'idx_room_uuid', columns: {#uuid})
class Room extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get uuid => text()();

  TextColumn get name => text()();

  TextColumn get typ => text()();
}

@TableIndex(name: 'idx_meterroom_room_id', columns: {#roomId})
@TableIndex(name: 'idx_meterroom_meter_id', columns: {#meterId})
class MeterInRoom extends Table {
  IntColumn get meterId =>
      integer().references(Meter, #id, onDelete: KeyAction.cascade)();

  TextColumn get roomId => text()();

  @override
  Set<Column> get primaryKey => {meterId, roomId};
}
