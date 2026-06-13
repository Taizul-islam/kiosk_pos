import 'package:flutter/material.dart';

class Responsive {
  // Kiosk is portrait - width varies
  static bool isNarrow(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;
  static bool isStandard(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800 &&
          MediaQuery.of(context).size.width < 1200;
  static bool isWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  // Grid always 2 columns for portrait kiosk
  static int get gridColumns => 2;
  static double get cardAspectRatio => 0.75;

  // Screen dimensions
  static double w(BuildContext context, double percent) =>
      MediaQuery.of(context).size.width * (percent / 100);
  static double h(BuildContext context, double percent) =>
      MediaQuery.of(context).size.height * (percent / 100);

  // Font scaling
  static double fs(BuildContext context, double base) {
    final scale = MediaQuery.of(context).size.width / 1080;
    return (base * scale).clamp(base * 0.8, base * 1.4);
  }

  // Touch target minimum
  static double get touchTarget => 56.0;
  static double get largeTouchTarget => 64.0;

  // Spacing
  static EdgeInsets padding(BuildContext context) => EdgeInsets.all(w(context, 4));
}