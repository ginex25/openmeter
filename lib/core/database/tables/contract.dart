import 'package:drift/drift.dart';

@TableIndex(name: 'idx_contract_archived', columns: {#isArchived})
@TableIndex(name: 'idx_contract_id', columns: {#id})
@TableIndex(
    name: 'idx_contract_archived_typ', columns: {#isArchived, #meterTyp})
class Contract extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get meterTyp => text()();

  IntColumn get provider => integer()
      .references(Provider, #id, onDelete: KeyAction.setNull)
      .nullable()();

  RealColumn get basicPrice => real()();

  RealColumn get energyPrice => real()();

  RealColumn get discount => real()();

  IntColumn get bonus => integer().nullable()();

  TextColumn get note => text()();

  TextColumn get unit => text()();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

@TableIndex(name: 'idx_provider_id', columns: {#id})
class Provider extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get contractNumber => text()();

  IntColumn get notice => integer().nullable()();

  DateTimeColumn get validFrom => dateTime()();

  DateTimeColumn get validUntil => dateTime()();

  IntColumn get renewal => integer().nullable()();

  BoolColumn get canceled => boolean().nullable()();

  DateTimeColumn get canceledDate => dateTime().nullable()();
}
