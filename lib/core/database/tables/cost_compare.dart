import 'package:drift/drift.dart';
import 'package:openmeter/core/database/tables/contract.dart';

@TableIndex(name: 'idx_cost_compare_id', columns: {#id})
@TableIndex(name: 'idx_cost_compare_parent_id', columns: {#parentId})
class CostCompare extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get basicPrice => real()();

  RealColumn get energyPrice => real()();

  IntColumn get bonus => integer()();

  IntColumn get usage => integer()();

  IntColumn get parentId =>
      integer().references(Contract, #id, onDelete: KeyAction.cascade)();
}
