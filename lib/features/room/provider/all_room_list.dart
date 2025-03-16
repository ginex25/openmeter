import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/core/model/room_dto.dart';
import 'package:openmeter/features/room/model/meter_room_dto.dart';
import 'package:openmeter/features/room/provider/details_room_provider.dart';
import 'package:openmeter/features/room/provider/room_list_provider.dart';
import 'package:openmeter/features/room/repository/room_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../database_settings/provider/has_update.dart';

part 'all_room_list.g.dart';

@riverpod
class AllRoomList extends _$AllRoomList {
  @override
  FutureOr<List<MeterRoomDto>> build(int roomId) async {
    final RoomRepository repo = ref.watch(roomRepositoryProvider);

    return await repo.fetchAllMeterWithRoom(roomId: roomId);
  }

  Future<void> saveSelectedMeters(
      {required List<MeterDto> selectedItemsWithExists,
      required List<MeterDto> selectedItemsWithoutExists,
      required RoomDto room}) async {
    final RoomRepository repo = ref.watch(roomRepositoryProvider);

    await repo.saveAllMetersWithRoom(
        roomId: room.uuid, meters: selectedItemsWithoutExists);
    await repo.updateAllMetersWithRoom(
        roomId: room.uuid, meters: selectedItemsWithExists);

    room.meters.addAll(selectedItemsWithExists);
    room.meters.addAll(selectedItemsWithoutExists);

    ref.read(detailsRoomProvider(roomId).notifier).updateRoom(room);
    ref.invalidate(roomListProvider);
    ref.read(hasUpdateProvider.notifier).setState(true);
  }
}
