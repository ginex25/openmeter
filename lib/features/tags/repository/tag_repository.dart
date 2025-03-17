import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/database/daos/tags_dao.dart';
import 'package:openmeter/core/database/local_database.dart';
import 'package:openmeter/core/exception/null_value.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_keys.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_provider.dart';
import 'package:openmeter/features/meters/model/meter_dto.dart';
import 'package:openmeter/features/tags/model/tag_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tag_repository.g.dart';

class TagRepository {
  final TagsDao _tagsDao;
  final SharedPreferencesWithCache _prefs;

  TagRepository(this._tagsDao, this._prefs);

  Future<List<TagDto>> fetchAllTags() async {
    final data = await _tagsDao.getAllTags();

    return data
        .map(
          (e) => TagDto.fromData(e),
        )
        .toList();
  }

  Future<TagDto> createTag(TagDto tag) async {
    final id = await _tagsDao.createTag(tag.toCompanion());

    tag.id = id;

    return tag;
  }

  Future<int> deleteTag(TagDto tag) async {
    if (tag.uuid == null) {
      throw NullValueException();
    }

    return await _tagsDao.deleteTag(tag.uuid!);
  }

  bool getShowTag() {
    return _prefs.getBool(SharedPreferencesKeys.shotTags) ?? false;
  }

  void saveShowTagState(bool state) {
    _prefs.setBool(SharedPreferencesKeys.shotTags, state);
  }

  Future<List<TagDto>> getTagsForMeter(int meterId) async {
    final data = await _tagsDao.getTagsForMeter(meterId);

    return data.map((e) => TagDto.fromData(e)).toList();
  }

  Future<int> createMeterWithTag(int meterId, String tagId) async {
    return await _tagsDao.createMeterWithTag(
        MeterWithTagsCompanion(meterId: Value(meterId), tagId: Value(tagId)));
  }

  Future removeAssoziation(MeterDto meter, String tagUuid) async {
    return await _tagsDao.removeAssoziation(tagUuid, meter.id!);
  }

  Future<int> getTableLength() async {
    return await _tagsDao.getTableLength() ?? 0;
  }
}

@riverpod
TagRepository tagRepository(Ref ref) {
  final LocalDatabase db = ref.watch(localDbProvider);

  return TagRepository(db.tagsDao, ref.watch(sharedPreferencesProvider));
}
