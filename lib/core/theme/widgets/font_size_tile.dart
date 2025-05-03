import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/theme/model/theme_model.dart';
import 'package:openmeter/core/theme/provider/theme_mode_provider.dart';

import '../model/font_size_value.dart';

class FontSizeTile extends ConsumerStatefulWidget {
  const FontSizeTile({super.key});

  @override
  ConsumerState<FontSizeTile> createState() => _FontSizeTileState();
}

class _FontSizeTileState extends ConsumerState<FontSizeTile> {
  FontSizeValue _selectedFontSize = FontSizeValue.normal;

  _onFontSizeChange(FontSizeValue? value) {
    ref
        .read(themeModeProviderProvider.notifier)
        .setFontSize(value ?? FontSizeValue.normal);

    Navigator.of(context).pop();
  }

  _showDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Schriftgröße auswählen',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: FontSizeValue.small,
                    groupValue: _selectedFontSize,
                    title: const Text('Klein'),
                    onChanged: _onFontSizeChange,
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: FontSizeValue.normal,
                    groupValue: _selectedFontSize,
                    title: const Text('Normal'),
                    onChanged: _onFontSizeChange,
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: FontSizeValue.large,
                    groupValue: _selectedFontSize,
                    title: const Text('Groß'),
                    onChanged: _onFontSizeChange,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeModel theme = ref.watch(themeModeProviderProvider);

    _selectedFontSize = theme.fontSize;

    return ListTile(
      onTap: () => _showDialog(),
      title: Text(
        'Schriftgröße',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(_selectedFontSize.text),
    );
  }
}
