import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_room_count_provider.g.dart';

@riverpod
class SelectedRoomCount extends _$SelectedRoomCount {
  @override
  int build() {
    return 0;
  }

  void setSelectedState(int value)  {
    state = value;
  }
}