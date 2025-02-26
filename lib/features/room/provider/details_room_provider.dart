import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/core/model/room_dto.dart';
import 'package:openmeter/features/room/model/details_room_model.dart';
import 'package:openmeter/features/room/provider/room_list_provider.dart';
import 'package:openmeter/features/room/repository/room_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'details_room_selected_meter.dart';

part 'details_room_provider.g.dart';

@riverpod
class DetailsRoom extends _$DetailsRoom {
  @override
  FutureOr<DetailsRoomDto> build(int roomId) async {
    final RoomRepository repo = ref.watch(roomRepositoryProvider);

    return await repo.fetchDetailsRoom(roomId);
  }

  Future updateRoom(RoomDto update) async {
    final RoomRepository repo = ref.watch(roomRepositoryProvider);

    await repo.updateRoom(update);

    final currentState = state.value!;

    final newDetails = DetailsRoomDto(update, currentState.meters);

    ref.read(roomListProvider.notifier).updateRoom(update);

    state = AsyncData(newDetails);
  }

  Future removeMeterFromRoom(MeterDto meter) async {
    final RoomRepository repo = ref.watch(roomRepositoryProvider);

    await repo.removeMeterFromRoom(meter);

    final currentState = state.value!;

    final currentMeters = currentState.meters;
    final currentRoom = currentState.room;

    currentMeters.removeWhere(
      (element) => element.id == meter.id,
    );

    currentRoom.meters = currentMeters;

    ref.read(roomListProvider.notifier).updateRoom(currentRoom);

    state = AsyncData(DetailsRoomDto(currentRoom, currentMeters));
  }

  void toggleSelectMeterState(MeterDto meter) {
    final currentState = state.value!;

    final currentMeters = currentState.meters;
    final currentRoom = currentState.room;

    int hasSelectedMeters = 0;

    for (MeterDto m in currentMeters) {
      if (m.id == meter.id) {
        m.isSelected = !m.isSelected;
      }

      if (m.isSelected) {
        hasSelectedMeters++;
      }
    }

    ref
        .read(detailsRoomSelectedMeterProvider.notifier)
        .setState(hasSelectedMeters);

    state = AsyncData(DetailsRoomDto(currentRoom, currentMeters));
  }

  void removeSelectedMetersState() {
    final currentState = state.value!;

    final currentMeters = currentState.meters;
    final currentRoom = currentState.room;

    for (MeterDto m in currentMeters) {
      if (m.isSelected) {
        m.isSelected = false;
      }
    }

    ref.read(detailsRoomSelectedMeterProvider.notifier).setState(0);

    state = AsyncData(DetailsRoomDto(currentRoom, currentMeters));
  }

  Future<void> removeAllSelectedMetersFromRoom() async {
    final currentState = state.value!;

    final currentMeters = currentState.meters;
    final currentRoom = currentState.room;

    final RoomRepository repo = ref.watch(roomRepositoryProvider);

    for (MeterDto m in currentMeters) {
      if (m.isSelected) {
        await repo.removeMeterFromRoom(m);
      }
    }

    currentMeters.removeWhere(
      (element) => element.isSelected,
    );

    currentRoom.meters = currentMeters;

    ref.read(roomListProvider.notifier).updateRoom(currentRoom);
    ref.read(detailsRoomSelectedMeterProvider.notifier).setState(0);

    state = AsyncData(DetailsRoomDto(currentRoom, currentMeters));
  }
}
