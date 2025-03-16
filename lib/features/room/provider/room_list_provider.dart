import 'package:drift/drift.dart' as drift;
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/core/model/room_dto.dart';
import 'package:openmeter/features/room/provider/selected_room_count_provider.dart';
import 'package:openmeter/features/room/repository/room_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../database_settings/provider/has_update.dart';

part 'room_list_provider.g.dart';

@Riverpod(keepAlive: true)
class RoomList extends _$RoomList {
  @override
  Future<(List<RoomDto>, List<RoomDto>)> build() async {
    final RoomRepository repo = ref.watch(roomRepositoryProvider);

    final result = await repo.fetchRooms();

    return repo.splitContracts(result);
  }

  Future addRoom(String roomType, String roomName, String uuid) async {
    final roomCompanion = RoomCompanion(
      typ: drift.Value(roomType),
      name: drift.Value(roomName),
      uuid: drift.Value(uuid),
    );

    final RoomRepository repo = ref.watch(roomRepositoryProvider);

    final newRoom = await repo.createRoom(roomCompanion);

    List<RoomDto> rooms = state.value!.$1 + state.value!.$2;

    rooms.add(newRoom);

    ref.read(hasUpdateProvider.notifier).setState(true);

    state = AsyncData(repo.splitContracts(rooms));
  }

  Future toggleState(RoomDto room) async {
    if (state.value == null) {
      return;
    }

    state = await AsyncValue.guard(() async {
      List<RoomDto> rooms = state.value!.$1 + state.value!.$2;

      int index = rooms.indexWhere(
        (element) => element.id == room.id,
      );

      rooms[index].isSelected = !rooms[index].isSelected;

      int selectedCount = 0;

      for (RoomDto contract in rooms) {
        if (contract.isSelected) {
          selectedCount++;
        }
      }

      ref
          .read(selectedRoomCountProvider.notifier)
          .setSelectedState(selectedCount);

      final repo = ref.watch(roomRepositoryProvider);

      return repo.splitContracts(rooms);
    });
  }

  Future removeAllSelectedState() async {
    if (state.value == null) {
      return;
    }

    state = await AsyncValue.guard(
      () async {
        List<RoomDto> allContracts = state.value!.$1 + state.value!.$2;

        for (RoomDto contract in allContracts) {
          if (contract.isSelected) {
            contract.isSelected = false;
          }
        }

        final repo = ref.watch(roomRepositoryProvider);

        return repo.splitContracts(allContracts);
      },
    );
  }

  Future deleteAllSelectedContracts() async {
    if (state.value == null) {
      return null;
    }

    final repo = ref.watch(roomRepositoryProvider);

    List<RoomDto> rooms = state.value!.$1 + state.value!.$2;

    for (RoomDto contract in rooms) {
      if (contract.isSelected && contract.id != null) {
        await repo.deleteRoom(contract);
      }
    }

    rooms.removeWhere((element) => element.isSelected);

    ref.read(selectedRoomCountProvider.notifier).setSelectedState(0);

    ref.read(hasUpdateProvider.notifier).setState(true);

    state = AsyncData(repo.splitContracts(rooms));
  }

  Future updateRoom(RoomDto room) async {
    if (state.value == null) {
      return null;
    }

    final repo = ref.watch(roomRepositoryProvider);

    List<RoomDto> rooms = state.value!.$1 + state.value!.$2;

    int updateIndex = rooms.indexWhere(
      (element) => element.id == room.id,
    );

    rooms[updateIndex] = room;

    ref.read(hasUpdateProvider.notifier).setState(true);

    state = AsyncData(repo.splitContracts(rooms));
  }
}
