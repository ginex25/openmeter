import 'package:openmeter/features/tags/repository/tag_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'show_tags_provider.g.dart';

@riverpod
class ShowTags extends _$ShowTags {
  @override
  bool build() {
    final repo = ref.watch(tagRepositoryProvider);

    return repo.getShowTag();
  }

  void setState(bool value) {
    final repo = ref.watch(tagRepositoryProvider);

    repo.saveShowTagState(value);

    state = value;
  }
}
