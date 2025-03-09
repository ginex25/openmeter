import 'package:openmeter/core/model/entry_dto.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/core/model/room_dto.dart';

class DetailsMeterModel {
  final MeterDto meter;
  final List<EntryDto> entries;
  final RoomDto? room;
  final String predictCount;

  DetailsMeterModel(
      {required this.meter,
      required this.entries,
      this.room,
      required this.predictCount});

  DetailsMeterModel copyWith(
          {MeterDto? meter,
          List<EntryDto>? entries,
          RoomDto? room,
          String? predictCount}) =>
      DetailsMeterModel(
          meter: meter ?? this.meter,
          entries: entries ?? this.entries,
          predictCount: predictCount ?? this.predictCount,
          room: room ?? this.room);
}
