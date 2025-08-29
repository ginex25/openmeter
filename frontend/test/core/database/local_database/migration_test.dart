// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openmeter/core/database/local_database.dart';

import 'generated/schema.dart';
import 'generated/schema_v10.dart' as v10;
import 'generated/schema_v11.dart' as v11;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = LocalDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test('migration from v10 to v11 does not corrupt data', () async {
    final oldMeterData = <v10.MeterData>[];
    final expectedNewMeterData = <v11.MeterData>[];

    final oldEntriesData = <v10.EntriesData>[];
    final expectedNewEntriesData = <v11.EntriesData>[];

    final oldRoomData = <v10.RoomData>[];
    final expectedNewRoomData = <v11.RoomData>[];

    final oldMeterInRoomData = <v10.MeterInRoomData>[];
    final expectedNewMeterInRoomData = <v11.MeterInRoomData>[];

    final oldProviderData = <v10.ProviderData>[];
    final expectedNewProviderData = <v11.ProviderData>[];

    final oldContractData = <v10.ContractData>[];
    final expectedNewContractData = <v11.ContractData>[];

    final oldTagsData = <v10.TagsData>[];
    final expectedNewTagsData = <v11.TagsData>[];

    final oldMeterWithTagsData = <v10.MeterWithTagsData>[];
    final expectedNewMeterWithTagsData = <v11.MeterWithTagsData>[];

    final oldCostCompareData = <v10.CostCompareData>[];
    final expectedNewCostCompareData = <v11.CostCompareData>[];

    final oldMeterContractData = <v10.MeterContractData>[];
    final expectedNewMeterContractData = <v11.MeterContractData>[];

    await verifier.testWithDataIntegrity(
      oldVersion: 10,
      newVersion: 11,
      createOld: v10.DatabaseAtV10.new,
      createNew: v11.DatabaseAtV11.new,
      openTestedDatabase: LocalDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.meter, oldMeterData);
        batch.insertAll(oldDb.entries, oldEntriesData);
        batch.insertAll(oldDb.room, oldRoomData);
        batch.insertAll(oldDb.meterInRoom, oldMeterInRoomData);
        batch.insertAll(oldDb.provider, oldProviderData);
        batch.insertAll(oldDb.contract, oldContractData);
        batch.insertAll(oldDb.tags, oldTagsData);
        batch.insertAll(oldDb.meterWithTags, oldMeterWithTagsData);
        batch.insertAll(oldDb.costCompare, oldCostCompareData);
        batch.insertAll(oldDb.meterContract, oldMeterContractData);
      },
      validateItems: (newDb) async {
        expect(expectedNewMeterData, await newDb.select(newDb.meter).get());
        expect(expectedNewEntriesData, await newDb.select(newDb.entries).get());
        expect(expectedNewRoomData, await newDb.select(newDb.room).get());
        expect(expectedNewMeterInRoomData,
            await newDb.select(newDb.meterInRoom).get());
        expect(
            expectedNewProviderData, await newDb.select(newDb.provider).get());
        expect(
            expectedNewContractData, await newDb.select(newDb.contract).get());
        expect(expectedNewTagsData, await newDb.select(newDb.tags).get());
        expect(expectedNewMeterWithTagsData,
            await newDb.select(newDb.meterWithTags).get());
        expect(expectedNewCostCompareData,
            await newDb.select(newDb.costCompare).get());
        expect(expectedNewMeterContractData,
            await newDb.select(newDb.meterContract).get());
      },
    );
  });
}
