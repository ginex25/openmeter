import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_keys.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_provider.dart';
import 'package:openmeter/features/database_settings/model/autobackup_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'autobackup_repository.g.dart';

class AutoBackupRepository {
  final SharedPreferencesWithCache _prefs;

  AutoBackupRepository(this._prefs);

  AutoBackupModel fetchData() {
    bool isActive =
        _prefs.getBool(SharedPreferencesKeys.autoBackupState) ?? false;
    bool deleteOldFiles =
        _prefs.getBool(SharedPreferencesKeys.autoBackupClearFiles) ?? false;

    String? path = _prefs.getString(SharedPreferencesKeys.autoBackupDir);

    if (path == null) {
      isActive = false;
    }

    return AutoBackupModel(isActive, deleteOldFiles, path ?? '');
  }

  void saveActiveState(bool value) {
    _prefs.setBool(SharedPreferencesKeys.autoBackupState, value);
  }

  void saveClearFilesState(bool value) {
    _prefs.setBool(SharedPreferencesKeys.autoBackupClearFiles, value);
  }

  void saveSelectedPath(String value) {
    _prefs.setString(SharedPreferencesKeys.autoBackupDir, value);
  }
}

@riverpod
AutoBackupRepository autobackupRepository(Ref ref) {
  return AutoBackupRepository(ref.watch(sharedPreferencesProvider));
}
