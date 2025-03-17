// import 'package:flutter/material.dart';
//
// class ColorAdjuster {
//   Color makeDark(Color color, [int percent = 80]) {
//     assert(1 <= percent && percent <= 100);
//
//     var f = 1 - percent / 100;
//
//     return Color.fromARGB(color.alpha, (color.red * f).round(),
//         (color.green * f).round(), (color.blue * f).round());
//   }
//
//   Color makeLight(Color color, [int percent = 80]) {
//     assert(1 <= percent && percent <= 100);
//
//     var p = percent / 100;
//
//     return Color.fromARGB(
//         color.alpha,
//         color.red + ((255 - color.red) * p).round(),
//         color.green + ((255 - color.green) * p).round(),
//         color.blue + ((255 - color.blue) * p).round());
//   }
// }

import 'dart:ui';

extension ColorUitl on Color {
  Color darkenColor({double percent = 0.05}) {
    percent = percent.clamp(0, 1);

    int red = (r * 255 * (1 - percent)).round();
    int green = (g * 255 * (1 - percent)).round();
    int blue = (b * 255 * (1 - percent)).round();

    red = red.clamp(0, 255);
    green = green.clamp(0, 255);
    blue = blue.clamp(0, 255);

    return Color.fromRGBO(red, green, blue, 1);
  }

  Color brighterColor({double percent = 0.25}) {
    double colorR = r * 255.0;
    double colorG = g * 255.0;
    double colorB = b * 255.0;

    int red = (colorR + (255 - colorR) * percent).round();
    int green = (colorG + (255 - colorG) * percent).round();
    int blue = (colorB + ((255 - colorB) * percent)).round();

    red = red.clamp(0, 255);
    green = green.clamp(0, 255);
    blue = blue.clamp(0, 255);

    return Color.fromRGBO(red, green, blue, 1);
  }

  int toInt() {
    final alpha = (a * 255.0).round() & 0xff;
    final red = (r * 255.0).round() & 0xff;
    final green = (g * 255.0).round() & 0xff;
    final blue = (b * 255.0).round() & 0xff;

    return (alpha << 24) | (red << 16) | (green << 8) | blue;
  }
}
