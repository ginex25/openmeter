import 'package:flutter/material.dart';
import 'package:openmeter/core/theme/model/font_size_value.dart';
import 'package:openmeter/shared/constant/custom_colors.dart';
import 'package:openmeter/shared/utils/color_adjuster.dart';

class GetThemes {
  static TextTheme _getTextTheme(FontSizeValue fontSize) {
    return TextTheme(
      bodySmall: TextStyle(fontSize: fontSize.size - 2),
      bodyMedium: TextStyle(fontSize: fontSize.size.toDouble()),
      bodyLarge: TextStyle(fontSize: fontSize.size + 2),
      headlineSmall: TextStyle(
          fontSize: fontSize.size.toDouble(), fontWeight: FontWeight.bold),
      headlineMedium:
          TextStyle(fontSize: fontSize.size + 2, fontWeight: FontWeight.bold),
      headlineLarge:
          TextStyle(fontSize: fontSize.size + 4, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(fontSize: fontSize.size - 4, color: Colors.grey),
      labelMedium: TextStyle(
        fontSize: fontSize.size - 2,
        color: Colors.grey,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: TextStyle(
        fontSize: fontSize.size.toDouble(),
        color: Colors.grey,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static ThemeData getLightTheme(ColorScheme? scheme, FontSizeValue fontSize) {
    final primaryColor = scheme?.primary ?? CustomColors.primaryColor;

    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      primaryColor: primaryColor,
      primaryColorLight: CustomColors.primaryColorLight2,
      colorScheme: scheme ??
          ColorScheme.fromSeed(
            seedColor: CustomColors.primaryColor,
            brightness: Brightness.light,
          ),
      textTheme: _getTextTheme(fontSize),
      floatingActionButtonTheme: scheme == null
          ? null
          : const FloatingActionButtonThemeData(
              backgroundColor: CustomColors.primaryColorLight),
      cardTheme: CardTheme(
        elevation: 1,
        color: primaryColor.brighterColor(percent: 100),
      ),
      indicatorColor: CustomColors.charcoal,
      highlightColor: Colors.black12,
    );
  }

  static ThemeData getDarkTheme(ColorScheme? scheme, FontSizeValue fontSize) {
    Color? darkDynamicColor;

    if (scheme != null) {
      darkDynamicColor = scheme.primary.darkenColor();
    }

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: scheme ??
          ColorScheme.fromSeed(
            seedColor: CustomColors.primaryColor,
            brightness: Brightness.dark,
          ),
      primaryColor: scheme?.primary ?? CustomColors.primaryColor,
      primaryColorDark: darkDynamicColor ?? CustomColors.primaryColorDark,
      scaffoldBackgroundColor: CustomColors.darkColor,
      appBarTheme: const AppBarTheme(
        color: CustomColors.darkColor,
      ),
      textTheme: _getTextTheme(fontSize),
      cardTheme: const CardTheme(elevation: 0, color: CustomColors.darkGrey),
    );
  }

  static ThemeData getNightTheme(ColorScheme? scheme, FontSizeValue fontSize) {
    final primaryColor = scheme?.primary ?? CustomColors.primaryColor;

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: scheme ??
          ColorScheme.fromSeed(
              seedColor: CustomColors.primaryColor,
              brightness: Brightness.dark),
      primaryColor: primaryColor,
      primaryColorLight: CustomColors.primaryColorDark,
      scaffoldBackgroundColor: CustomColors.nightColor,
      appBarTheme: const AppBarTheme(
        color: CustomColors.nightColor,
      ),
      textTheme: _getTextTheme(fontSize),
      cardTheme: CardTheme(
        elevation: 0,
        color: primaryColor.darkenColor(percent: 0.94),
      ),
    );
  }
}
