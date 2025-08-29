import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_searching.g.dart';

@riverpod
class IsSearching extends _$IsSearching {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}
