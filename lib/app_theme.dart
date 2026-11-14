import 'package:flutter/material.dart';

class AppThemeController {
  // Mencegah pembuatan instance controller karena seluruh akses bersifat statis.
  AppThemeController._();

  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);

  // Mengganti mode tema dari terang ke gelap atau sebaliknya.
  static void toggle() {
    mode.value = mode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}
