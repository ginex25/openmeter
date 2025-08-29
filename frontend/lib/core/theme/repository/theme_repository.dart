import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_keys.dart';
import 'package:openmeter/core/shared_preferences/shared_preferences_provider.dart';
import 'package:openmeter/core/theme/model/font_size_value.dart';
import 'package:openmeter/core/theme/model/theme_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'theme_repository.g.dart';

class ThemeRepository {
  final SharedPreferencesWithCache _prefs;

  ThemeRepository(this._prefs);

  ThemeMode getThemeMode() {
    final savedThemeMode = _prefs.getString(SharedPreferencesKeys.theme);

    if (savedThemeMode == null) {
      return ThemeMode.light;
    }

    return ThemeMode.values.firstWhere(
      (element) => element.name == savedThemeMode,
      orElse: () => ThemeMode.light,
    );
  }

  FontSizeValue getFontSize() {
    final savedFontSize = _prefs.getString(SharedPreferencesKeys.themeFontSize);

    if (savedFontSize == null) {
      return FontSizeValue.normal;
    }

    return FontSizeValue.values.firstWhere(
      (element) => element.name == savedFontSize,
      orElse: () => FontSizeValue.normal,
    );
  }

  ThemeModel loadThemeModel() {
    final ThemeMode mode = getThemeMode();

    bool amoled = _prefs.getBool(SharedPreferencesKeys.themeNight) ?? false;
    bool dynamicColor =
        _prefs.getBool(SharedPreferencesKeys.themeDynamicColor) ?? false;

    FontSizeValue fontSize = getFontSize();

    bool compactNavBar =
        _prefs.getBool(SharedPreferencesKeys.themeCompactNavBar) ?? false;

    return ThemeModel(mode, amoled, dynamicColor, compactNavBar, fontSize);
  }

  void setFontSize(FontSizeValue value) {
    _prefs.setString(SharedPreferencesKeys.themeFontSize, value.name);
  }

  void setThemeMode(ThemeMode value) {
    _prefs.setString(SharedPreferencesKeys.theme, value.name);
  }

  void setNightState(bool value) {
    _prefs.setBool(SharedPreferencesKeys.themeNight, value);
  }

  void setDynamicColorState(bool value) {
    _prefs.setBool(SharedPreferencesKeys.themeDynamicColor, value);
  }

  void setCompactNavigationBar(bool value) {
    _prefs.setBool(SharedPreferencesKeys.themeCompactNavBar, value);
  }

  void setKeepDisplayAwake(bool value) {
    _prefs.setBool(SharedPreferencesKeys.displayAwake, value);

    WakelockPlus.toggle(enable: value);
  }

  bool getKeepDisplayAwake() {
    final bool keepAwake =
        _prefs.getBool(SharedPreferencesKeys.displayAwake) ?? false;

    WakelockPlus.toggle(enable: keepAwake);

    return keepAwake;
  }
}

@riverpod
ThemeRepository themeRepository(Ref ref) {
  return ThemeRepository(ref.watch(sharedPreferencesProvider));
}
