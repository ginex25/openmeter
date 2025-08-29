import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/tags/provider/tag_list_provider.dart';
import 'package:openmeter/shared/constant/custom_colors.dart';
import 'package:openmeter/shared/utils/color_adjuster.dart';

import '../model/tag_chip_state.dart';
import '../model/tag_dto.dart';

class TagChip extends StatelessWidget {
  final TagDto tag;

  final TagChipState state;

  const TagChip({
    super.key,
    required this.tag,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case TagChipState.delete:
        return DeleteTag(tag);
      case TagChipState.checked:
        return CheckedTag(tag: tag);
      default:
        return SimpleTag(tag: tag);
    }
  }
}

class DeleteTag extends ConsumerWidget {
  final TagDto tag;

  const DeleteTag(this.tag, {super.key});

  Future _deleteDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Löschen?'),
          content: const Text('Möchten Sie den Tag wirklich löschen?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                ref.read(tagListProvider.notifier).deleteTag(tag);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Löschen',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Color(tag.color),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              tag.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _deleteDialog(context, ref),
            icon: const Icon(
              Icons.cancel,
              color: Colors.white,
            ),
            tooltip: 'Tag löschen',
          ),
        ],
      ),
    );
  }
}

class CheckedTag extends StatelessWidget {
  final TagDto tag;

  const CheckedTag({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(tag.color),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check,
            color: Colors.white,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            tag.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleTag extends StatelessWidget {
  final TagDto tag;

  const SimpleTag({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(tag.color),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      width: tag.name.length * 10.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tag.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class CanceledTag extends StatelessWidget {
  const CanceledTag({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleTag(
      tag: TagDto.fromValue(
        name: 'gekündigt',
        color: CustomColors.canceled.toInt(),
      ),
    );
  }
}

class ShouldCancelTag extends StatelessWidget {
  const ShouldCancelTag({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleTag(
      tag: TagDto.fromValue(
        name: 'kündigen',
        color: CustomColors.yellow.toInt(),
      ),
    );
  }
}
