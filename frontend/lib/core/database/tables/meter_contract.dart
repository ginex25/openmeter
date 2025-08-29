import 'package:drift/drift.dart';
import 'package:openmeter/core/database/tables/contract.dart';
import 'package:openmeter/core/database/tables/meter.dart';

class MeterContract extends Table {
  IntColumn get meterId =>
      integer().references(Meter, #id, onDelete: KeyAction.cascade)();

  IntColumn get contractId =>
      integer().references(Contract, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {meterId, contractId};
}
