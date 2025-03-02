import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/model/tag_dto.dart';
import 'package:openmeter/features/tags/provider/meter_tags_list.dart';
import 'package:openmeter/features/tags/widget/tag_chip.dart';

class HorizontalTagsList extends ConsumerWidget {
  final int meterId;
  final Function(bool)? setHasTags;
  final Function(List<TagDto>)? setTags;

  const HorizontalTagsList({
    super.key,
    required this.meterId,
    this.setHasTags,
    this.setTags,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagProvider = ref.watch(meterTagsListProvider(meterId));

    return tagProvider.when(
      data: (tags) {
        if (tags.isEmpty) {
          return SizedBox();
        }

        return Container(
          alignment: Alignment.centerLeft,
          height: 30,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final TagDto tag = tags.elementAt(index);

              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SizedBox(
                  width: 70,
                  child: SimpleTag(tag: tag),
                ),
              );
            },
          ),
        );
      },
      error: (error, stackTrace) => throw error,
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
