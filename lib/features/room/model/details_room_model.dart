import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/core/model/room_dto.dart';

class DetailsRoomDto {
  final RoomDto room;
  final List<MeterDto> meters;

  DetailsRoomDto(this.room, this.meters);
}
