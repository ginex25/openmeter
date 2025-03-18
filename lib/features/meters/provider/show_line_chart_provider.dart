import 'package:openmeter/core/shared_preferences/shared_preferences_keys.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'show_line_chart_provider.g.dart';

@riverpod
class ShowLineChart extends _$ShowLineChart {
  @override
  bool build() {
    final SharedPreferencesWithCache prefs =
        ref.watch(sharedPreferencesProvider);

    return prefs.getBool(SharedPreferencesKeys.showLineChart) ?? true;
  }

  void setState(bool value) {
    final SharedPreferencesWithCache prefs =
        ref.watch(sharedPreferencesProvider);

    prefs.setBool(SharedPreferencesKeys.showLineChart, value);

    state = value;
  }
}
