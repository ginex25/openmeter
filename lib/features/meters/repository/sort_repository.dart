import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_keys.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_provider.dart';
import 'package:openmeter/features/meters/model/sort_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sort_repository.g.dart';

class SortRepository {
  final SharedPreferencesWithCache _prefs;

  SortRepository(this._prefs);

  SortModel loadSortModel() {
    final sort = _prefs.getString(SharedPreferencesKeys.meterSort) ?? 'room';
    final String order =
        _prefs.getString(SharedPreferencesKeys.meterOrder) ?? 'asc';

    return SortModel(order, sort);
  }

  void saveSort(String value) {
    _prefs.setString(SharedPreferencesKeys.meterSort, value);
  }

  void saveOrder(String value) {
    _prefs.setString(SharedPreferencesKeys.meterOrder, value);
  }
}

@riverpod
SortRepository sortRepository(Ref ref) {
  return SortRepository(ref.watch(sharedPreferencesProvider));
}
