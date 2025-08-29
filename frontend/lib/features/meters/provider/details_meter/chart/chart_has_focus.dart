import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chart_has_focus.g.dart';

@riverpod
class ChartHasFocus extends _$ChartHasFocus {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}
