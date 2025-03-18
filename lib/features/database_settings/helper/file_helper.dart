import 'dart:developer';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:openmeter/shared/constant/datetime_formats.dart';
import 'package:openmeter/shared/constant/log.dart';

class FileHelper {
  final RegExp _clearBackupSearchPattern =
      RegExp(r'meter_(\d{4}_\d{2}_\d{2}_\d{2}_\d{2}_\d{2})');

  final RegExp _getDateInMeterPattern = RegExp(r'meter_(\d{4}_\d{2}_\d{2})');

  /// Sort all files with the same date
  Map<String, List<FileSystemEntity>> _sortFiles(List<FileSystemEntity> files) {
    Map<String, List<FileSystemEntity>> filesByDate = {};

    for (FileSystemEntity file in files) {
      Match? match = _getDateInMeterPattern.firstMatch(file.path);

      if (match != null) {
        String? dateKey = match.group(1);

        filesByDate.putIfAbsent(dateKey ?? '', () => []);
        filesByDate[dateKey]!.add(file);
      }
    }

    return filesByDate;
  }

  // Delete all files, except the last one, from the lists
  // If the key is today's date, the entire list is deleted
  void _deleteFiles(Map<String, List<FileSystemEntity>> files) {
    DateTime now = DateTime.now();
    String formattedNow = DateFormat(DateTimeFormats.dateShort).format(now);

    files.forEach((key, value) {
      // delete the files for today's date
      if (key == formattedNow) {
        for (var element in value) {
          try {
            element.deleteSync(recursive: true);

            log('$element wurde erfolgreich gelöscht',
                name: LogNames.databaseExportImport);
          } catch (e) {
            log(e.toString(), name: LogNames.databaseExportImport);
          }
        }

        value.clear();
      }

      // delete files if more than one file is present
      if (value.length > 1) {
        for (int i = 0; i < value.length - 1; i++) {
          try {
            value.elementAt(i).deleteSync(recursive: true);

            log('${value[i]} wurde erfolgreich gelöscht',
                name: LogNames.databaseExportImport);
          } catch (e) {
            log(e.toString(), name: LogNames.databaseExportImport);
          }

          value.removeAt(i);
        }
      }
    });
  }

  /// delete all backup files except the latest two
  Future<void> clearLastBackupFiles(String path) async {
    Directory dir = Directory(path);
    List<FileSystemEntity> files = dir.listSync();

    files.sort((a, b) => a.uri.path.compareTo(b.uri.path));
    files.removeWhere((element) =>
        element is! File ||
        _clearBackupSearchPattern.firstMatch(element.path) == null);

    Map<String, List<FileSystemEntity>> filesByDate = _sortFiles(files);

    _deleteFiles(filesByDate);

    List<List<FileSystemEntity>> fileValues = filesByDate.values.toList();

    fileValues.removeWhere((element) => element.isEmpty);

    // Delete all files except for the oldest two
    if (fileValues.length > 1) {
      for (int i = 0; i < fileValues.length - 1; i++) {
        final value = fileValues.elementAt(i);

        if (value.isNotEmpty) {
          try {
            value.elementAt(0).deleteSync(recursive: true);

            log('${value[0]} wurde erfolgreich gelöscht',
                name: LogNames.databaseExportImport);
          } catch (e) {
            log(e.toString(), name: LogNames.databaseExportImport);
          }
        }
      }
    }
  }
}
