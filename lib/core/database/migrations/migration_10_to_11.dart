import 'package:drift/drift.dart';

Future<void> migration10to11(Migrator m) async {
  await m.createIndex(
      Index('idx_meter_id', 'CREATE INDEX idx_meter_id ON meter (id)'));
  await m.createIndex(
      Index('idx_meter_type', 'CREATE INDEX idx_meter_type ON meter (typ)'));
  await m.createIndex(Index('idx_meter_archived',
      'CREATE INDEX idx_meter_archived ON meter (is_archived)'));
  await m.createIndex(Index('idx_entry_meter_id',
      'CREATE INDEX idx_entry_meter_id ON entries (meter)'));
  await m.createIndex(
      Index('idx_entry_id', 'CREATE INDEX idx_entry_id ON entries (id)'));
  await m.createIndex(
      Index('idx_room_id', 'CREATE INDEX idx_room_id ON room (id)'));
  await m.createIndex(
      Index('idx_room_uuid', 'CREATE INDEX idx_room_uuid ON room (uuid)'));
  await m.createIndex(Index('idx_meterroom_room_id',
      'CREATE INDEX idx_meterroom_room_id ON meter_in_room (room_id)'));
  await m.createIndex(Index('idx_meterroom_meter_id',
      'CREATE INDEX idx_meterroom_meter_id ON meter_in_room (meter_id)'));
  await m.createIndex(Index('idx_contract_archived',
      'CREATE INDEX idx_contract_archived ON contract (is_archived)'));
  await m.createIndex(Index(
      'idx_contract_id', 'CREATE INDEX idx_contract_id ON contract (id)'));
  await m.createIndex(Index('idx_contract_archived_typ',
      'CREATE INDEX idx_contract_archived_typ ON contract (is_archived, meter_typ)'));
  await m.createIndex(Index(
      'idx_provider_id', 'CREATE INDEX idx_provider_id ON provider (id)'));
  await m
      .createIndex(Index('idx_tag_id', 'CREATE INDEX idx_tag_id ON tags (id)'));
  await m.createIndex(
      Index('idx_tag_uuid', 'CREATE INDEX idx_tag_uuid ON tags (uuid)'));
  await m.createIndex(Index('idx_metertag_meter_id',
      'CREATE INDEX idx_metertag_meter_id ON meter_with_tags (meter_id)'));
  await m.createIndex(Index('idx_metertag_tag_id',
      'CREATE INDEX idx_metertag_tag_id ON meter_with_tags (tag_id)'));
  await m.createIndex(Index('idx_cost_compare_id',
      'CREATE INDEX idx_cost_compare_id ON cost_compare (id)'));
  await m.createIndex(Index('idx_cost_compare_parent_id',
      'CREATE INDEX idx_cost_compare_parent_id ON cost_compare (parent_id)'));
}
