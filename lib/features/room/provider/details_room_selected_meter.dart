import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'details_room_selected_meter.g.dart';

@riverpod
class DetailsRoomSelectedMeter extends _$DetailsRoomSelectedMeter {
  @override
  int build() {
    return 0;
  }

  void setState(int count) {
    state = count;
  }
}
