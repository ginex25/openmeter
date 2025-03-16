import 'package:openmeter/core/exception/null_value.dart';
import 'package:openmeter/core/model/meter_dto.dart';
import 'package:openmeter/features/meters/provider/archvied_meters_count_provider.dart';
import 'package:openmeter/features/meters/provider/meter_list_provider.dart';
import 'package:openmeter/features/meters/provider/selected_meters_count.dart';
import 'package:openmeter/features/meters/repository/meter_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../database_settings/provider/has_update.dart';

part 'archived_meters_list_provider.g.dart';

@Riverpod(keepAlive: true)
class ArchivedMetersList extends _$ArchivedMetersList {
  @override
  FutureOr<List<MeterDto>> build() async {
    final MeterRepository repo = ref.watch(meterRepositoryProvider);

    return await repo.fetchMeters(isArchived: true);
  }

  void setArchiveCount(int count) {
    ref.read(archivedMetersCountProvider.notifier).setState(count);
  }

  Future<void> addMeterToArchiv(MeterDto meter) async {
    if (state.value == null) {
      throw NullValueException();
    }

    meter.isSelected = false;
    meter.isArchived = true;

    final MeterRepository repo = ref.watch(meterRepositoryProvider);
    await repo.saveMeterArchiveState(meter);

    final currentMeters = state.value!;

    currentMeters.add(meter);

    setArchiveCount(currentMeters.length);
    ref.read(hasUpdateProvider.notifier).setState(true);

    state = AsyncData(currentMeters);
  }

  Future<void> removeFromArchive(MeterDto meter) async {
    if (state.value == null) {
      throw NullValueException();
    }

    final currentMeters = state.value!;
    currentMeters.remove(meter);

    meter.isArchived = false;
    ref.read(meterListProvider.notifier).addMeter(meter);

    final MeterRepository repo = ref.watch(meterRepositoryProvider);
    await repo.saveMeterArchiveState(meter);

    setArchiveCount(currentMeters.length);

    state = AsyncData(currentMeters);
  }

  Future<void> unarchiveSelectedMeters() async {
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
        meter.isSelected = false;

        await ref.read(meterListProvider.notifier).addMeter(meter);
      }
    }

    ref.read(selectedMetersCountProvider.notifier).setSelectedState(0);

    setArchiveCount(result.length);
    ref.read(hasUpdateProvider.notifier).setState(true);

    state = AsyncData(result);
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

    setArchiveCount(meters.length);
    ref.read(hasUpdateProvider.notifier).setState(true);

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

    setArchiveCount(meters.length);

    ref.read(selectedMetersCountProvider.notifier).setSelectedState(0);
    ref.read(hasUpdateProvider.notifier).setState(true);

    state = AsyncData(meters);
  }
}
