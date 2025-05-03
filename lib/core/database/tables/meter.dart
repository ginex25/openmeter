import 'package:drift/drift.dart';

@TableIndex(name: 'idx_meter_id', columns: {#id})
@TableIndex(name: 'idx_meter_type', columns: {#typ})
@TableIndex(name: 'idx_meter_archived', columns: {#isArchived})
class Meter extends Table {
  IntColumn get id => integer().autoIncrement()(); // default primary key
  TextColumn get typ => text()();

  TextColumn get note => text()();

  TextColumn get number => text()();

  TextColumn get unit => text()();

  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))(); // schema v2
}
