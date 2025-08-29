import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/theme/model/theme_model.dart';
import 'package:openmeter/core/theme/provider/theme_mode_provider.dart';

class DynamicColorTile extends ConsumerWidget {
  const DynamicColorTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeModel theme = ref.watch(themeModeProviderProvider);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return SwitchListTile(
          value: theme.dynamicColor,
          title: Text(
            'Dynamische Farben',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          onChanged: (value) {
            ref
                .read(themeModeProviderProvider.notifier)
                .setDynamicColorState(value);
          },
        );
      },
    );
  }
}
