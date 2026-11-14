import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'providers/quiz_provider.dart';
import 'screens/home_screen.dart';

void main() {
  // Menjalankan aplikasi dan menyediakan QuizProvider untuk seluruh widget.
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => QuizProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // Membuat widget utama aplikasi.
  const MyApp({super.key});

  // Membangun MaterialApp dengan tema yang sedang dipilih pengguna.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeController.mode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Ruang Kuis',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          home: const HomeScreen(),
        );
      },
    );
  }

  // Membuat konfigurasi tema terang atau gelap.
  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF356AE6),
      brightness: brightness,
      primary: const Color(0xFF5D8BFF),
      surface: isDark ? const Color(0xFF182033) : const Color(0xFFFFF8E7),
      error: const Color(0xFFD64545),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scheme.surface,
      colorScheme: scheme,
      inputDecorationTheme: InputDecorationTheme(
        fillColor: isDark ? const Color(0xFF222C40) : const Color(0xFFFFFCF3),
      ),
      textTheme: const TextTheme().apply(
        fontFamily: 'Manrope',
        bodyColor: isDark ? Color(0xFFE8EDF7) : Color(0xFF1D2D44),
        displayColor: isDark ? Color(0xFFE8EDF7) : Color(0xFF1D2D44),
      ),
      fontFamily: 'Manrope',
    );
  }
}
