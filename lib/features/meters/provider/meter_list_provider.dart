import 'package:openmeter/core/exception/null_value.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/core/model/room_dto.dart';
import 'package:openmeter/features/meters/provider/archived_meters_list_provider.dart';
import 'package:openmeter/features/meters/provider/selected_meters_count.dart';
import 'package:openmeter/features/meters/repository/meter_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meter_list_provider.g.dart';

@Riverpod(keepAlive: true)
class MeterList extends _$MeterList {
  @override
  Future<List<MeterDto>> build() async {
    final MeterRepository repo = ref.watch(meterRepositoryProvider);

    return await repo.fetchMeters();
  }

  void toggleMeterSelectedState(MeterDto selectedMeter) {
    if (state.value == null) {
      throw NullValueException();
    }

    final List<MeterDto> meters = state.value!;

    int count = 0;

    for (MeterDto meter in meters) {
      if (meter == selectedMeter) {
        meter.isSelected = !meter.isSelected;
      }

      if (meter.isSelected) {
        count++;
      }
    }

    ref.read(selectedMetersCountProvider.notifier).setSelectedState(count);

    state = AsyncData(meters);
  }

  void removeAllSelectedMetersState() {
    if (state.value == null) {
      throw NullValueException();
    }

    final List<MeterDto> meters = state.value!;

    for (MeterDto meter in meters) {
      if (meter.isSelected) {
        meter.isSelected = false;
      }
    }

    ref.read(selectedMetersCountProvider.notifier).setSelectedState(0);

    state = AsyncData(meters);
  }

  Future<void> deleteMeter(MeterDto meter) async {
    if (state.value == null) {
      throw NullValueException();
    }

    final MeterRepository repo = ref.watch(meterRepositoryProvider);
    await repo.deleteSingleMeter(meter);

    final List<MeterDto> meters = state.value!;

    meters.removeWhere(
      (element) => element == meter,
    );

    state = AsyncData(meters);
  }

  Future<void> deleteAllSelectedMeters() async {
    if (state.value == null) {
      throw NullValueException();
    }

    final MeterRepository repo = ref.watch(meterRepositoryProvider);
    final List<MeterDto> meters = state.value!;

    for (MeterDto meter in meters) {
      if (meter.isSelected) {
        await repo.deleteSingleMeter(meter);
      }
    }

    meters.removeWhere(
      (element) => element.isSelected,
    );

    ref.read(selectedMetersCountProvider.notifier).setSelectedState(0);

    state = AsyncData(meters);
  }

  Future<void> resetAllSelectedMeters() async {
    if (state.value == null) {
      throw NullValueException();
    }

    final MeterRepository repo = ref.watch(meterRepositoryProvider);
    final List<MeterDto> meters = state.value!;

    for (MeterDto meter in meters) {
      if (meter.isSelected) {
        meter = await repo.resetMeter(meter);
        meter.isSelected = false;
      }
    }

    meters.removeWhere(
      (element) => element.isSelected,
    );

    ref.read(selectedMetersCountProvider.notifier).setSelectedState(0);

    state = AsyncData(meters);
  }

  Future<void> createMeter(
      MeterDto meter, int meterCount, RoomDto? room, List<String> tags) async {
    if (state.value == null) {
      throw NullValueException();
    }

    final MeterRepository repo = ref.watch(meterRepositoryProvider);

    final MeterDto newMeter = await repo.createMeter(
        meter: meter, currentCount: meterCount, room: room, tags: tags);

    final currentMeters = state.value!;

    currentMeters.add(newMeter);

    state = AsyncData(currentMeters);
  }

  Future<void> archiveMeter(MeterDto meter) async {
    if (state.value == null) {
      throw NullValueException();
    }

    await ref.read(archivedMetersListProvider.notifier).addMeterToArchiv(meter);

    final currentMeters = state.value!;

    currentMeters.remove(meter);

    state = AsyncData(currentMeters);
  }

  Future<void> addMeter(MeterDto meter) async {
    if (state.value == null) {
      throw NullValueException();
    }

    final currentMeters = state.value!;

    currentMeters.add(meter);

    state = AsyncData(currentMeters);
  }

  Future<void> archiveSelectedMeters() async {
    if (state.value == null) {
      throw NullValueException();
    }

    final currentMeters = state.value!;

    final List<MeterDto> result = List.of(currentMeters);

    result.removeWhere(
      (element) => element.isSelected,
    );

    for (MeterDto meter in currentMeters) {
      if (meter.isSelected) {
        await ref
            .read(archivedMetersListProvider.notifier)
            .addMeterToArchiv(meter);
      }
    }

    ref.read(selectedMetersCountProvider.notifier).setSelectedState(0);

    state = AsyncData(result);
  }
}
