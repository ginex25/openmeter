import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/torch/provider/active_torch_state_provider.dart';

class ActiveTorchTile extends ConsumerWidget {
  const ActiveTorchTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool activeTorch = ref.watch(activeTorchStateProviderProvider);

    return SwitchListTile(
      title: Text(
        'Taschenlampe',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: const Text(
          'Die Taschenlampe wird bei der Ablesung automatisch eingeschaltet.'),
      secondary: activeTorch == false
          ? const Icon(Icons.flashlight_off)
          : const Icon(Icons.flashlight_on),
      value: activeTorch,
      onChanged: (value) {
        ref.read(activeTorchStateProviderProvider.notifier).setState(value);
      },
    );
  }
}
