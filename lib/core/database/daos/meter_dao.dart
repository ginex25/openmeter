import 'package:drift/drift.dart';

import '../local_database.dart';
import '../model/meter_with_room.dart';
import '../tables/entries.dart';
import '../tables/meter.dart';
import '../tables/room.dart';

part 'meter_dao.g.dart';

class EntryWithMeter {
  final Meter meter;
  final Entries entries;

  EntryWithMeter(this.meter, this.entries);
}

@DriftAccessor(tables: [Meter, Entries, MeterInRoom, Room])
class MeterDao extends DatabaseAccessor<LocalDatabase> with _$MeterDaoMixin {
  final LocalDatabase db;

  MeterDao(this.db) : super(db);

  Future<int> createMeter(MeterCompanion meter) async {
    return await db.into(db.meter).insert(meter);
  }

  Future<int> deleteMeter(int meterId) async {
    batch((batch) =>
        batch.deleteWhere(db.entries, (tbl) => tbl.meter.equals(meterId)));
    return await (db.delete(db.meter)..where((tbl) => tbl.id.equals(meterId)))
        .go();
  }

  Future updateMeter(MeterData meter) async {
    return update(db.meter).replace(meter);
  }

  Future<List<MeterData>> getAllMeter() async {
    return await select(db.meter).get();
  }

  Stream<List<MeterData>> watchAllMeter() {
    return select(db.meter).watch();
  }

  Future<MeterData> getSingleMeter(int meterId) {
    return (select(db.meter)..where((tbl) => tbl.id.equals(meterId)))
        .getSingle();
  }

  Stream<List<MeterWithRoom>> watchAllMeterWithRooms(bool isArchived) {
    final query = select(db.meter).join([
      leftOuterJoin(
        db.meterInRoom,
        meter.id.equalsExp(meterInRoom.meterId),
        // useColumns: false,
      ),
      leftOuterJoin(
        db.room,
        meterInRoom.roomId.equalsExp(room.uuid),
        // useColumns: false,
      ),
    ])
      ..where(meter.isArchived.equals(isArchived));

    return query.watch().map(
      (rows) {
        return rows.map((row) {
          return MeterWithRoom(
            meter: row.readTable(db.meter),
            room: row.readTableOrNull(db.room),
            isSelected: false,
          );
        }).toList();
      },
    );
  }

  Future updateArchived(int meterId, bool isArchived) async {
    return (update(meter)..where((tbl) => tbl.id.equals(meterId)))
        .write(MeterCompanion(isArchived: Value(isArchived)));
  }

  Future<List<MeterWithRoom>> getAllMeterWithRooms({bool? isArchived}) {
    final query = select(db.meter).join([
      leftOuterJoin(
        db.meterInRoom,
        meter.id.equalsExp(meterInRoom.meterId),
        // useColumns: false,
      ),
      leftOuterJoin(
        db.room,
        meterInRoom.roomId.equalsExp(room.uuid),
        // useColumns: false,
      ),
    ]);

    if (isArchived != null) {
      query.where(meter.isArchived.equals(isArchived));
    }

    return query
        .map(
          (row) => MeterWithRoom(
            meter: row.readTable(db.meter),
            room: row.readTableOrNull(db.room),
            isSelected: false,
          ),
        )
        .get();
  }

  Future<List<String?>> getAllMeterTyps() async {
    final query = selectOnly(db.meter, distinct: true)..addColumns([meter.typ]);

    List<String?> result = await query.map((row) => row.read(meter.typ)).get();

    result.sort(
      (a, b) => a!.compareTo(b!),
    );

    return result;
  }

  Future<int?> getTableLength() async {
    var count = db.meter.id.count();

    return await (db.selectOnly(db.meter)..addColumns([count]))
        .map((row) => row.read(count))
        .getSingleOrNull();
  }

  Future<MeterContractData?> getMeterContract(int meterId) async {
    final query = select(db.meterContract)
      ..where(
        (tbl) => tbl.meterId.equals(meterId),
      );

    return query.getSingleOrNull();
  }

  Future<int> createMeterContract(int meterId, int contractId,
      DateTime? startDate, DateTime? endDate) async {
    return await db.into(db.meterContract).insert(
          MeterContractCompanion(
            endDate: Value(endDate),
            startDate: Value(startDate),
            contractId: Value(contractId),
            meterId: Value(meterId),
          ),
        );
  }

  Future<void> updateContractForMeter(
      int meterId, MeterContractCompanion companion) async {
    await (update(db.meterContract)
          ..where((tbl) => tbl.meterId.equals(meterId)))
        .write(companion);
  }

  Future<void> removeContractFromMeter(int meterId) async {
    await (delete(db.meterContract)
          ..where((tbl) => tbl.meterId.equals(meterId)))
        .go();
  }

  Future<int> countMeters(bool isArchived) async {
    final query = db.meter.id.count();

    final result = await (selectOnly(db.meter)
          ..addColumns([query])
          ..where(db.meter.isArchived.equals(isArchived)))
        .getSingle();

    return result.read(query) ?? 0;
  }
}
