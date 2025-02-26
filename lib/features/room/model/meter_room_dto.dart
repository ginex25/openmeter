import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/core/model/room_dto.dart';

class MeterRoomDto {
  final RoomDto? room;
  final MeterDto meter;
  bool isInCurrentRoom = false;
  bool isInARoom = false;

  MeterRoomDto(this.room, this.meter, this.isInCurrentRoom, this.isInARoom);
}
