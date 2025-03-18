import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_provider_state.g.dart';

@riverpod
class DeleteProviderState extends _$DeleteProviderState {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}
