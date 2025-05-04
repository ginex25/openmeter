import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/meters/provider/meter_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_meter_provider.g.dart';

@riverpod
class SearchMeter extends _$SearchMeter {
  @override
  List<MeterDto>? build() {
    return null;
  }

  void searchMeter(String searchText) {
    final List<MeterDto>? currentMeters = ref.watch(meterListProvider).value;

    if (currentMeters == null) {
      return;
    }

    final List<MeterDto> result = [];

    final lowerCaseSearch = searchText.toLowerCase();

    for (MeterDto meter in currentMeters) {
      final containsRoomName = meter.room?.name.toLowerCase().contains(lowerCaseSearch) ?? false;

      if (meter.typ.toLowerCase().contains(lowerCaseSearch) || meter.number.toLowerCase().contains(lowerCaseSearch) || containsRoomName) {
        result.add(meter);
      }
    }

    state = result;
  }

  void resetSearchState() {
    state = null;
  }
}
