import 'package:openmeter/core/shared_preferences/shared_preferences_keys.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_provider.dart';
import 'package:openmeter/features/meters/repository/meter_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'archvied_meters_count_provider.g.dart';

@Riverpod(keepAlive: true)
class ArchivedMetersCount extends _$ArchivedMetersCount {
  @override
  Future<int> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);

    int? count = prefs.getInt(SharedPreferencesKeys.meterLastArchiveCount);

    if (count == null) {
      final repo = ref.watch(meterRepositoryProvider);

      count = await repo.countMeters(true);
    }

    return count;
  }

  void setState(int value) {
    state = AsyncData(value);

    final prefs = ref.watch(sharedPreferencesProvider);
    prefs.setInt(SharedPreferencesKeys.meterLastArchiveCount, value);
  }
}
