import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_meters_count.g.dart';

@riverpod
class SelectedMetersCount extends _$SelectedMetersCount {
  @override
  int build() {
    return 0;
  }

  Future<void> setSelectedState(int value) async {
    state = value;
  }
}
