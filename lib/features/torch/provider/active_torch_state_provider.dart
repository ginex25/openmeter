import 'package:openmeter/features/torch/repository/torch_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_torch_state_provider.g.dart';

@riverpod
class ActiveTorchStateProvider extends _$ActiveTorchStateProvider {
  @override
  bool build() {
    final TorchRepository repo = ref.watch(torchRepositoryProvider);

    return repo.getActiveTorchState();
  }

  void setState(bool value) {
    final TorchRepository repo = ref.watch(torchRepositoryProvider);

    repo.setActiveTorchState(value);

    state = value;
  }
}
