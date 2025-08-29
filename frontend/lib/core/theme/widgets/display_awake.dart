import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/theme/provider/keep_awake_provider.dart';

class DisplayAwake extends ConsumerWidget {
  const DisplayAwake({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool awake = ref.watch(keepAwakeProvider);

    return SwitchListTile(
      title: Text(
        'Bildschirmsperre verhindern',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      value: awake,
      onChanged: (value) {
        ref.read(keepAwakeProvider.notifier).setState(value);
      },
    );
  }
}
