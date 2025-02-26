import 'package:openmeter/core/database/local_database.dart';

class RoomModel {
  final RoomData room;
  final MeterData? meter;

  RoomModel(this.room, this.meter);
}
