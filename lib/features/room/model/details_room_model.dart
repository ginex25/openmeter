import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/room/model/room_dto.dart';

class DetailsRoomDto {
  final RoomDto room;
  final List<MeterDto> meters;

  DetailsRoomDto(this.room, this.meters);
}
