import 'package:drift/drift.dart';

import '../database/local_database.dart';

class EntryDto {
  int? id;
  int? meterId;
  int count;
  int usage;
  int days;
  String? note;
  DateTime date;
  bool transmittedToProvider;
  bool isReset;
  bool isSelected = false;
  String? imagePath;

  EntryDto(
      {this.id,
      this.meterId,
      required this.count,
      this.usage = -1,
      this.days = -1,
      this.note,
      required this.date,
      this.transmittedToProvider = false,
      this.isReset = false,
      this.isSelected = false,
      this.imagePath});

  EntryDto.fromData(Entry entry)
      : count = entry.count,
        usage = entry.usage,
        days = entry.days,
        note = entry.note,
        date = entry.date,
        transmittedToProvider = entry.transmittedToProvider,
        isReset = entry.isReset,
        id = entry.id,
        meterId = entry.meter,
        imagePath = entry.imagePath;

  EntryDto.fromJson(Map<String, dynamic> json)
      : count = json['count'],
        usage = json['usage'],
        days = json['days'],
        note = json['note'],
        date = DateTime.parse(json['date']),
        transmittedToProvider = json['transmittedToProvider'],
        isReset = json['isReset'],
        imagePath = json['imagePath'];

  static Map<String, dynamic> entriesToJson(Entry entry) {
    return {
      'count': entry.count,
      'days': entry.days,
      'usage': entry.usage,
      'note': entry.note,
      'date': entry.date.toString(),
      'transmittedToProvider': entry.transmittedToProvider,
      'isReset': entry.isReset,
      'imagePath': entry.imagePath
    };
  }

  EntryDto.fromEntriesCompanion(EntriesCompanion companion)
      : count = companion.count.value,
        date = companion.date.value,
        usage = companion.usage.value,
        days = companion.days.value,
        isReset = companion.isReset.value,
        transmittedToProvider = companion.transmittedToProvider.value,
        imagePath = companion.imagePath.value;

  EntriesCompanion toCompanion() => EntriesCompanion(
        count: Value(count),
        date: Value(date),
        meter: Value(meterId!),
        usage: Value(usage),
        days: Value(days),
        note: Value(note),
        transmittedToProvider: Value(transmittedToProvider),
        imagePath: Value(imagePath),
        isReset: Value(isReset),
      );
}
