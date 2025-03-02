import 'package:openmeter/core/model/tag_dto.dart';
import 'package:openmeter/features/tags/repository/tag_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meter_tags_list.g.dart';

@Riverpod(keepAlive: true)
class MeterTagsList extends _$MeterTagsList {
  @override
  FutureOr<List<TagDto>> build(int meterId) async {
    final TagRepository repo = ref.watch(tagRepositoryProvider);

    return await repo.getTagsForMeter(meterId);
  }
}
