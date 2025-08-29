import 'package:drift/drift.dart';

import 'meter.dart';

@TableIndex(name: 'idx_tag_id', columns: {#id})
@TableIndex(name: 'idx_tag_uuid', columns: {#uuid})
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get uuid => text()();

  TextColumn get name => text()();

  IntColumn get color => integer()();
}

@TableIndex(name: 'idx_metertag_meter_id', columns: {#meterId})
@TableIndex(name: 'idx_metertag_tag_id', columns: {#tagId})
class MeterWithTags extends Table {
  IntColumn get meterId =>
      integer().references(Meter, #id, onDelete: KeyAction.cascade)();

  TextColumn get tagId => text()();

  @override
  Set<Column<Object>>? get primaryKey => {meterId, tagId};
}
