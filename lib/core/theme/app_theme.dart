import 'package:flutter/material.dart';


class AppPalette {
  AppPalette._();

  static const primary = Color(0xFF1E5F6C);
  static const primaryLight = Color(0xFF4DA6A6);
  static const primaryDark = Color(0xFF0D2F30);
  static const secondary = Color(0xFF299999);
  static const error = Color(0xFFDC2626);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF06191B);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppPalette.surfaceLight,
        colorScheme: const ColorScheme.light(
          primary: AppPalette.primary,
          onPrimary: Colors.white,
          secondary: AppPalette.secondary,
          onSecondary: Colors.white,
          surface: AppPalette.surfaceLight,
          onSurface: Colors.black,
          error: AppPalette.error,
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppPalette.surfaceDark,
        colorScheme: const ColorScheme.dark(
          primary: AppPalette.primaryLight,
          onPrimary: Colors.black,
          secondary: AppPalette.secondary,
          onSecondary: Colors.black,
          surface: AppPalette.primaryDark,
          onSurface: Colors.white,
          error: AppPalette.error,
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      );
}
