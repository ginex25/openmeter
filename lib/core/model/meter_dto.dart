import 'package:drift/drift.dart';

import '../database/local_database.dart';
import 'entry_dto.dart';

class MeterDto {
  int? id;
  String typ;
  String number;
  String unit;
  String note;
  String? room;
  bool isArchived;
  List<String> tags;
  bool isSelected;
  bool hasEntry = false;
  EntryDto? lastEntry;

  MeterDto(
      {this.id,
      required this.typ,
      required this.number,
      required this.unit,
      this.note = '',
      this.room,
      this.isArchived = false,
      required this.tags,
      this.isSelected = false,
      this.hasEntry = false,
      this.lastEntry});

  MeterDto.fromData(MeterData data, this.hasEntry)
      : typ = data.typ,
        number = data.number,
        unit = data.unit,
        note = data.note,
        isArchived = data.isArchived,
        isSelected = false,
        id = data.id,
        tags = [];

  MeterDto.fromJson(Map<String, dynamic> json)
      : typ = json['typ'],
        number = json['number'],
        unit = json['unit'],
        note = json['note'],
        room = json['room'],
        tags = json['tags'],
        isArchived = json['isArchived'],
        isSelected = false;

  MeterData toMeterData() {
    return MeterData(
      unit: unit,
      typ: typ,
      number: number,
      note: note,
      isArchived: isArchived,
      id: id!,
    );
  }

  MeterCompanion toMeterCompanion() => MeterCompanion(
      isArchived: Value(isArchived),
      typ: Value(typ),
      note: Value(note),
      number: Value(number),
      unit: Value(unit));
}
