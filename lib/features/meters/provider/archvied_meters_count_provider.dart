import 'package:openmeter/core/shared_preferences/shared_preferences_keys.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'archvied_meters_count_provider.g.dart';

@riverpod
class ArchivedMetersCount extends _$ArchivedMetersCount {
  @override
  int build() {
    final prefs = ref.watch(sharedPreferencesProvider);

    return prefs.getInt(SharedPreferencesKeys.meterLastArchiveCount) ?? 0;
  }

  void setState(int value) {
    state = value;

    final prefs = ref.watch(sharedPreferencesProvider);
    prefs.setInt(SharedPreferencesKeys.meterLastArchiveCount, value);
  }
}
