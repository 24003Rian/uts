import 'package:flutter/material.dart';

class AppThemeController {
  AppThemeController._();

  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);

  static void toggle() {
    mode.value = mode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}
