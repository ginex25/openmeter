import 'package:flutter/material.dart';
import 'package:openmeter/core/theme/model/font_size_value.dart';

class ThemeModel {
  final ThemeMode mode;
  final bool amoled;
  final bool dynamicColor;
  final bool compactNavigation;
  final FontSizeValue fontSize;

  ThemeModel(this.mode, this.amoled, this.dynamicColor, this.compactNavigation,
      this.fontSize);

  ThemeModel copyWith(
          {ThemeMode? mode,
          bool? amoled,
          bool? dynamicColor,
          bool? compactNavigation,
          FontSizeValue? fontSize}) =>
      ThemeModel(
          mode ?? this.mode,
          amoled ?? this.amoled,
          dynamicColor ?? this.dynamicColor,
          compactNavigation ?? this.compactNavigation,
          fontSize ?? this.fontSize);
}
