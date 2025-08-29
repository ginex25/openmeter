import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/tags/provider/tag_list_provider.dart';
import 'package:openmeter/features/tags/widget/tag_chip.dart';

class CurrentTagsList extends ConsumerWidget {
  const CurrentTagsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsProvider = ref.watch(tagListProvider);

    return tagsProvider.when(
      data: (tags) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aktuelle Tags:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (tags.isEmpty) NoTags(),
            if (tags.isNotEmpty)
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 4),
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: DeleteTag(tags[index]),
                  );
                },
              )
          ],
        );
      },
      error: (error, stackTrace) => throw error,
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class NoTags extends StatelessWidget {
  const NoTags({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Es sind keine Tags vorhanden!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Text(
              'Drücke jetzt auf das + um einen neuen Tag zu erstellen!',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
