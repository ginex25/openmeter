import 'package:openmeter/core/exception/null_value.dart';
import 'package:openmeter/features/database_settings/provider/has_update.dart';
import 'package:openmeter/features/meters/helper/entry_helper.dart';
import 'package:openmeter/features/meters/model/details_meter_model.dart';
import 'package:openmeter/features/meters/model/entry_dto.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/meters/provider/details_meter/cost/meter_cost_provider.dart';
import 'package:openmeter/features/meters/provider/details_meter/entry/selected_entries_count.dart';
import 'package:openmeter/features/meters/provider/meter_list_provider.dart';
import 'package:openmeter/features/meters/repository/entry_repository.dart';
import 'package:openmeter/features/meters/repository/meter_repository.dart';
import 'package:openmeter/features/room/model/room_dto.dart';
import 'package:openmeter/features/room/provider/details_room_provider.dart';
import 'package:openmeter/features/room/provider/room_list_provider.dart';
import 'package:openmeter/features/tags/provider/meter_tags_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'details_meter_provider.g.dart';

@Riverpod(keepAlive: true)
class DetailsMeter extends _$DetailsMeter {
  @override
  FutureOr<DetailsMeterModel> build(int meterId) async {
    final MeterRepository repo = ref.watch(meterRepositoryProvider);

    return await repo.fetchDetailsMeter(meterId, true);
  }

  Future<void> addEntry(EntryDto newEntry) async {
    if (state.value == null) {
      throw NullValueException();
    }

    final EntryRepository entryRepo = ref.watch(entryRepositoryProvider);

    List<EntryDto> currentEntries = state.value!.entries;

    final newEntriesList = await entryRepo.addNewEntry(currentEntries, newEntry);

    MeterDto meter = state.value!.meter;
    meter.lastEntry = newEntriesList.first;

    ref.read(meterListProvider.notifier).updateMeterInfo(meter);

    final newDetails = state.value!.copyWith(entries: newEntriesList, meter: meter);

    ref.invalidate(meterCostProviderProvider);
    ref.read(hasUpdateProvider.notifier).setState(true);
    _updateDetailsRoom(meter.room, null);

    state = AsyncData(newDetails);
  }

  Future<void> toggleSelectedEntry(EntryDto selectedEntry) async {
    if (state.value == null) {
      throw NullValueException();
    }

    List<EntryDto> currentEntries = state.value!.entries;

    int count = 0;

    for (EntryDto entry in currentEntries) {
      if (entry.id == selectedEntry.id) {
        entry.isSelected = !entry.isSelected;
      }

      if (entry.isSelected) {
        count++;
      }
    }

    ref.read(selectedEntriesCountProvider.notifier).setState(count);

    final newDetails = state.value!.copyWith(entries: currentEntries);

    state = AsyncData(newDetails);
  }

  void removeSelectedEntitiesState() {
    if (state.value == null) {
      throw NullValueException();
    }

    List<EntryDto> currentEntries = state.value!.entries;

    for (EntryDto entry in currentEntries) {
      if (entry.isSelected) {
        entry.isSelected = false;
      }
    }

    ref.read(selectedEntriesCountProvider.notifier).setState(0);

    final newDetails = state.value!.copyWith(entries: currentEntries);

    state = AsyncData(newDetails);
  }

  Future<void> deleteSelectedEntries() async {
    if (state.value == null) {
      throw NullValueException();
    }

    List<EntryDto> currentEntries = state.value!.entries;

    final EntryRepository repo = ref.watch(entryRepositoryProvider);

    for (EntryDto entry in currentEntries) {
      if (entry.isSelected) {
        await repo.deleteEntry(entry);
      }
    }

    currentEntries.removeWhere((element) => element.isSelected);

    ref.read(selectedEntriesCountProvider.notifier).setState(0);

    final MeterDto meter = state.value!.meter;
    meter.lastEntry = currentEntries.first;

    ref.read(meterListProvider.notifier).updateMeterInfo(meter);

    final newDetails = state.value!.copyWith(entries: currentEntries, meter: meter);


    ref.invalidate(meterCostProviderProvider);
    ref.read(hasUpdateProvider.notifier).setState(true);
    _updateDetailsRoom(meter.room, null);

    state = AsyncData(newDetails);
  }

  Future<void> updateMeter(MeterDto meter, RoomDto? newRoom, List<String> tags) async {
    if (state.value == null) {
      throw NullValueException();
    }

    final MeterRepository repo = ref.watch(meterRepositoryProvider);

    final newMeter = await repo.updateMeter(oldMeter: state.value!.meter, tags: tags, newMeter: meter, newRoom: newRoom);

    _updateDetailsRoom(meter.room, newRoom);

    final newDetails = state.value!.copyWith(meter: newMeter, room: newRoom);

    ref.read(meterListProvider.notifier).updateMeterInfo(newMeter);
    ref.invalidate(meterTagsListProvider(meterId));

    ref.invalidate(meterCostProviderProvider);
    ref.invalidate(roomListProvider);

    ref.read(hasUpdateProvider.notifier).setState(true);

    state = AsyncData(newDetails);
  }

  Future<void> updateEntry(EntryDto entry) async {
    if (state.value == null) {
      throw NullValueException();
    }

    final currentEntries = state.value!.entries;

    int index = currentEntries.indexWhere(
      (element) => element.id == entry.id,
    );

    if (entry.isReset) {
      entry.usage = -1;
      entry.days = -1;
    } else if (entry.usage == -1 && entry.days == -1 && currentEntries.length > 1) {
      final helper = EntryHelper();

      final prevEntry = currentEntries.elementAtOrNull(index + 1);

      if (prevEntry != null) {
        entry.usage = helper.calcUsage(prevEntry.count.toString(), entry.count);
        entry.days = helper.calcDays(entry.date, prevEntry.date);
      }
    }

    final EntryRepository repo = ref.watch(entryRepositoryProvider);

    await repo.updateEntry(entry);

    currentEntries[index] = entry;

    final newDetails = state.value!.copyWith(entries: currentEntries);

    ref.read(hasUpdateProvider.notifier).setState(true);
    _updateDetailsRoom(newDetails.meter.room, null);

    state = AsyncData(newDetails);
  }

  void _updateDetailsRoom(RoomDto? oldRoom, RoomDto? newRoom){
    if (oldRoom != null) ref.invalidate(detailsRoomProvider(oldRoom.id!));
    if(newRoom != null) ref.invalidate(detailsRoomProvider(newRoom.id!));
  }
}
