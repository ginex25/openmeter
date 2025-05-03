import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'in_app_action.g.dart';

@riverpod
class InAppAction extends _$InAppAction {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}
