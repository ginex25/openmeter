import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/tags/widget/add_tags.dart';
import 'package:openmeter/features/tags/widget/current_tags_list.dart';
import 'package:openmeter/features/tags/widget/show_tags_tile.dart';

class TagsScreen extends ConsumerStatefulWidget {
  const TagsScreen({super.key});

  @override
  ConsumerState createState() => _TagsScreenState();
}

class _TagsScreenState extends ConsumerState<TagsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Tags'),
          actions: [
            AddTagButton(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 30,
              children: [
                Center(
                  child: Image.asset(
                    'assets/icons/tag.png',
                    width: 200,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const ShowTagsTile(),
                const CurrentTagsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
