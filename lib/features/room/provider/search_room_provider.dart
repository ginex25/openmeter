import 'package:openmeter/features/room/helper/room_helper.dart';
import 'package:openmeter/features/room/provider/room_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/room_dto.dart';

part 'search_room_provider.g.dart';

@riverpod
class SearchRoom extends _$SearchRoom {
  @override
  (List<RoomDto>, List<RoomDto>)? build() {
    return null;
  }

  void searchRoom(String searchText) {
    final (List<RoomDto>, List<RoomDto>)? currentRooms = ref.watch(roomListProvider).value;

    if (currentRooms == null) {
      return;
    }

    final helper = RoomHelper();

    state = helper.searchRoom(searchText, currentRooms.$1 + currentRooms.$2);
  }

  void resetSearchState() {
    state = null;
  }
}
