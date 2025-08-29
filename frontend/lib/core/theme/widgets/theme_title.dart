import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/theme/model/theme_model.dart';
import 'package:openmeter/core/theme/provider/theme_mode_provider.dart';

class ThemeTitle extends ConsumerStatefulWidget {
  const ThemeTitle({super.key});

  @override
  ConsumerState<ThemeTitle> createState() => _ThemeTitleState();
}

class _ThemeTitleState extends ConsumerState<ThemeTitle> {
  _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'Dunkel';
      case ThemeMode.light:
        return 'Hell';
      case ThemeMode.system:
        return 'System';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeModel theme = ref.watch(themeModeProviderProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            'Design',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Text(_getThemeModeText(theme.mode)),
          onTap: () => _themeDialog(theme.mode),
        ),
        SwitchListTile(
          title: Text(
            'Schwarzer Hintergrund',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          // subtitle: const Text('Nur möglich, wenn das dunkle Design ausgewählt ist'),
          value: theme.amoled,
          onChanged: (value) {
            if (theme.mode == ThemeMode.dark ||
                MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    theme.mode == ThemeMode.system) {
              ref
                  .read(themeModeProviderProvider.notifier)
                  .setAmoledState(value);
            }
          },
        ),
      ],
    );
  }

  void _onModeChange(ThemeMode? value) {
    ref
        .read(themeModeProviderProvider.notifier)
        .setThemeMode(value ?? ThemeMode.light);

    Navigator.of(context).pop();
  }

  Future<void> _themeDialog(ThemeMode selectedRadio) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Design auswählen',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    value: ThemeMode.system,
                    groupValue: selectedRadio,
                    title: const Text('System'),
                    contentPadding: const EdgeInsets.all(0),
                    onChanged: _onModeChange,
                  ),
                  RadioListTile(
                    value: ThemeMode.light,
                    groupValue: selectedRadio,
                    title: const Text('Hell'),
                    contentPadding: const EdgeInsets.all(0),
                    onChanged: _onModeChange,
                  ),
                  RadioListTile(
                    value: ThemeMode.dark,
                    groupValue: selectedRadio,
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text('Dunkle'),
                    onChanged: _onModeChange,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
