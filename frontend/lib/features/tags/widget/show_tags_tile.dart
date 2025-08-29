import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openmeter/features/tags/provider/show_tags_provider.dart';

class ShowTagsTile extends ConsumerWidget {
  const ShowTagsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool showTags = ref.watch(showTagsProvider);

    return SwitchListTile(
      title: const Text('Tags anzeigen'),
      subtitle:
          const Text('Ermöglicht das anzeigen eines Tags auf der Startseite.'),
      secondary: showTags
          ? FaIcon(
              FontAwesomeIcons.eye,
              color: Theme.of(context).indicatorColor,
            )
          : FaIcon(
              FontAwesomeIcons.eyeSlash,
              color: Theme.of(context).indicatorColor,
            ),
      value: showTags,
      onChanged: (value) {
        ref.read(showTagsProvider.notifier).setState(value);
      },
    );
  }
}
