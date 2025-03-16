import 'package:openmeter/core/exception/null_value.dart';
import 'package:openmeter/core/model/tag_dto.dart';
import 'package:openmeter/features/tags/repository/tag_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../database_settings/provider/has_update.dart';

part 'tag_list_provider.g.dart';

@riverpod
class TagList extends _$TagList {
  @override
  FutureOr<List<TagDto>> build() async {
    final repo = ref.watch(tagRepositoryProvider);

    return await repo.fetchAllTags();
  }

  Future<void> deleteTag(TagDto tag) async {
    if (state.value == null) {
      throw NullValueException();
    }

    final currentTags = state.value!;

    final repo = ref.watch(tagRepositoryProvider);

    await repo.deleteTag(tag);

    currentTags.removeWhere(
      (element) => element.id == tag.id,
    );

    ref.read(hasUpdateProvider.notifier).setState(true);

    state = AsyncData(currentTags);
  }

  Future<void> addTag(TagDto tag) async {
    if (state.value == null) {
      throw NullValueException();
    }

    final repo = ref.watch(tagRepositoryProvider);

    TagDto newTag = await repo.createTag(tag);

    final currentTags = state.value!;

    currentTags.add(newTag);

    ref.read(hasUpdateProvider.notifier).setState(true);

    state = AsyncData(currentTags);
  }
}
