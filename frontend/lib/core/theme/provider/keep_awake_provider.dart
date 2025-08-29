import 'package:openmeter/core/theme/repository/theme_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'keep_awake_provider.g.dart';

@riverpod
class KeepAwake extends _$KeepAwake {
  @override
  bool build() {
    final repo = ref.watch(themeRepositoryProvider);

    return repo.getKeepDisplayAwake();
  }

  void setState(bool value) {
    final repo = ref.watch(themeRepositoryProvider);

    repo.setKeepDisplayAwake(value);

    state = value;
  }
}
