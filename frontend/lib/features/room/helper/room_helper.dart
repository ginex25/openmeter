import 'package:collection/collection.dart';
import 'package:openmeter/features/room/model/room_dto.dart';

class RoomHelper {
  (List<RoomDto>, List<RoomDto>) splitRooms(Iterable<RoomDto> rooms) {
    rooms = rooms.sortedBy(
      (element) {
        return element.typ;
      },
    );

    List<RoomDto> firstRow = [];
    List<RoomDto> secondRow = [];

    for (int i = 0; i < rooms.length; i++) {
      if (i % 2 == 0) {
        firstRow.add(rooms.elementAt(i));
      } else {
        secondRow.add(rooms.elementAt(i));
      }
    }

    return (firstRow, secondRow);
  }

  (List<RoomDto>, List<RoomDto>) searchRoom(String searchText, List<RoomDto> rooms) {
    final List<RoomDto> result = [];

    for (RoomDto room in rooms) {
      if (room.typ.toLowerCase().contains(searchText.toLowerCase()) || room.name.toLowerCase().contains(searchText.toLowerCase())) {
        result.add(room);
      }
    }

    if (rooms.isEmpty) {
      return ([], []);
    }

    return splitRooms(result);
  }
}
