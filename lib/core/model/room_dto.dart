import 'package:drift/drift.dart';
import 'package:openmeter/core/model/meter_dto.dart';

import '../database/local_database.dart';

class RoomDto {
  int? id;
  String uuid;
  String name;
  String typ;
  bool isSelected = false;
  int? sumMeter; // Todo remove sumMeter
  List<MeterDto> meters = [];

  RoomDto.fromData(RoomData data)
      : id = data.id,
        uuid = data.uuid,
        name = data.name,
        typ = data.typ,
        isSelected = false;

  RoomData toData() => RoomData(id: id!, name: name, typ: typ, uuid: uuid);

  RoomDto.fromCompanion(RoomCompanion data)
      : uuid = data.uuid.value,
        name = data.name.value,
        typ = data.typ.value;

  RoomDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uuid = json['uuid'],
        name = json['name'],
        typ = json['typ'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'typ': typ,
    };
  }

  RoomCompanion toCompanion() =>
      RoomCompanion(typ: Value(typ), name: Value(name), uuid: Value(uuid));
}
