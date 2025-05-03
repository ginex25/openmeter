import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/theme/model/theme_model.dart';
import 'package:openmeter/core/theme/provider/theme_mode_provider.dart';

class CompactNavBarSettings extends ConsumerWidget {
  const CompactNavBarSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeModel theme = ref.watch(themeModeProviderProvider);

    return SwitchListTile(
      value: theme.compactNavigation,
      title: Text(
        'Kompakte Navigationsleiste',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onChanged: (value) {
        ref
            .read(themeModeProviderProvider.notifier)
            .setCompactNavigation(value);
      },
    );
  }
}
