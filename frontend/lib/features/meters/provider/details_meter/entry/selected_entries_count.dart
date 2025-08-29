import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_entries_count.g.dart';

@riverpod
class SelectedEntriesCount extends _$SelectedEntriesCount {
  @override
  int build() {
    return 0;
  }

  void setState(int value) {
    state = value;
  }
}
