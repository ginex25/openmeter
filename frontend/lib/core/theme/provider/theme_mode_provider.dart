import 'package:flutter/material.dart';
import 'package:openmeter/core/theme/model/font_size_value.dart';
import 'package:openmeter/core/theme/model/theme_model.dart';
import 'package:openmeter/core/theme/repository/theme_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_provider.g.dart';

@riverpod
class ThemeModeProvider extends _$ThemeModeProvider {
  @override
  ThemeModel build() {
    final repo = ref.watch(themeRepositoryProvider);

    return repo.loadThemeModel();
  }

  void setThemeMode(ThemeMode mode) {
    final repo = ref.watch(themeRepositoryProvider);

    repo.setThemeMode(mode);

    state = state.copyWith(mode: mode);
  }

  void setAmoledState(bool value) {
    final repo = ref.watch(themeRepositoryProvider);

    repo.setNightState(value);

    state = state.copyWith(amoled: value);
  }

  void setDynamicColorState(bool value) {
    final repo = ref.watch(themeRepositoryProvider);

    repo.setDynamicColorState(value);

    state = state.copyWith(dynamicColor: value);
  }

  void setCompactNavigation(bool value) {
    final repo = ref.watch(themeRepositoryProvider);

    repo.setCompactNavigationBar(value);

    state = state.copyWith(compactNavigation: value);
  }

  void setFontSize(FontSizeValue value) {
    final repo = ref.watch(themeRepositoryProvider);

    repo.setFontSize(value);

    state = state.copyWith(fontSize: value);
  }
}
