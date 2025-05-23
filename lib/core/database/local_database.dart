import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openmeter/core/database/local_database.steps.dart';
import 'package:openmeter/core/database/migrations/migrations.dart';
import 'package:openmeter/core/database/tables/meter_contract.dart';
import 'package:openmeter/shared/constant/datetime_formats.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqlite3/sqlite3.dart';

import 'daos/contract_dao.dart';
import 'daos/cost_compare_dao.dart';
import 'daos/entry_dao.dart';
import 'daos/meter_dao.dart';
import 'daos/room_dao.dart';
import 'daos/tags_dao.dart';
import 'tables/contract.dart' as c;
import 'tables/cost_compare.dart';
import 'tables/entries.dart';
import 'tables/meter.dart';
import 'tables/room.dart';
import 'tables/tags.dart';

part 'local_database.g.dart';

// create => dart run

@DriftDatabase(tables: [
  Meter,
  Entries,
  Room,
  MeterInRoom,
  c.Contract,
  c.Provider,
  Tags,
  MeterWithTags,
  CostCompare,
  MeterContract,
], daos: [
  MeterDao,
  EntryDao,
  RoomDao,
  ContractDao,
  TagsDao,
  CostCompareDao
])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      }, onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.addColumn(meter, meter.isArchived);
        }
        if (from < 3) {
          await m.addColumn(provider, provider.canceled);
          await m.addColumn(provider, provider.renewal);
        }
        if (from < 4) {
          await m.addColumn(provider, provider.canceledDate);
        }
        if (from < 5) {
          await m.addColumn(entries, entries.isReset);
        }
        if (from < 6) {
          await m.addColumn(entries, entries.transmittedToProvider);
        }
        if (from < 7) {
          await m.addColumn(entries, entries.imagePath);
        }
        if (from < 10) {
          await m.createTable(meterContract);
        }

        await m.runMigrationSteps(
          from: from,
          to: to,
          steps: migrationSteps(
            from10To11: (m, schema) async => await migration10to11(m),
          ),
        );
      });

  Future<void> exportInto(String path, bool isBackup) async {
    String newPath = '';
    DateTime date = DateTime.now();

    String formattedDate =
        DateFormat(DateTimeFormats.timestamp12H).format(date);

    if (isBackup) {
      newPath = p.join(path, 'meter_$formattedDate.db');
    } else {
      newPath = p.join(path, 'meter.db');
    }

    final File file = await File(newPath).create(recursive: true);

    if (file.existsSync()) {
      file.deleteSync();
    }

    await customStatement('VACUUM INTO ?', [newPath]);
  }

  Future<void> importDB(String path) async {
    final newDB = sqlite3.open(path);
    final appDir = await getApplicationDocumentsDirectory();
    final File file = File(p.join(appDir.path, 'meter.db'));

    if (file.existsSync()) {
      file.deleteSync();
    }

    // file.copy(path);
    newDB.execute('VACUUM INTO ?', [file.path]);

    // https://github.com/simolus3/drift/issues/376
  }

  Future<void> deleteDB() async {
    const statement = 'PRAGMA foreign_keys = OFF';
    await customStatement(statement);
    try {
      transaction(() async {
        for (final table in allTables) {
          await delete(table).go();
        }
      });
    } finally {
      await customStatement(statement);
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'meter.db'));

    // if (!await file.exists()) {
    //   final blob = await rootBundle.load(p.join(dbFolder.path, 'meter.db'));
    //   final buffer = blob.buffer;
    //   await file.writeAsBytes(
    //       buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes));
    // }

    return NativeDatabase.createInBackground(file);
  });
}

@Riverpod(keepAlive: true)
LocalDatabase localDb(Ref ref) {
  final db = LocalDatabase();

  ref.onDispose(() {
    db.close();
  });

  return db;
}
