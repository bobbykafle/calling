import 'package:flutter/material.dart';
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.primaryBlue,
    required this.lightBlue,
    required this.white,
    required this.black,
    required this.offWhite,
    required this.cream,
    required this.reacher,
    required this.hintColor,
  });

  final Color primaryBlue;
  final Color lightBlue;
  final Color white;
  final Color black;
  final Color offWhite;
  final Color cream;
  final Color reacher;
  final Color hintColor;

  @override
  AppColorsExtension copyWith({
    Color? primaryBlue,
    Color? lightBlue,
    Color? white,
    Color? black,
    Color? offWhite,
    Color? cream,
    Color? reacher,
    Color? hintColor,
  }) {
    return AppColorsExtension(
      primaryBlue: primaryBlue ?? this.primaryBlue,
      lightBlue: lightBlue ?? this.lightBlue,
      white: white ?? this.white,
      black: black ?? this.black,
      offWhite: offWhite ?? this.offWhite,
      cream: cream ?? this.cream,
      reacher: reacher ?? this.reacher,
      hintColor: hintColor ?? this.hintColor,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primaryBlue: Color.lerp(primaryBlue, other.primaryBlue, t)!,
      lightBlue: Color.lerp(lightBlue, other.lightBlue, t)!,
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
      offWhite: Color.lerp(offWhite, other.offWhite, t)!,
      cream: Color.lerp(cream, other.cream, t)!,
      reacher: Color.lerp(reacher, other.reacher, t)!,
      hintColor: Color.lerp(hintColor, other.hintColor, t)!,
    );
  }
}

class AppTheme {
  AppTheme._();

  // Primary palette matching active UI elements 
  static const Color _primary = Color(0xFF00A8E8);
  static const Color _error = Color(0xFFDC2626);

  // Surface Colors
  static const Color _lightSurface = Color(0xFFFAF9F6);
  static const Color _darkSurface = Color(0xFF121212);
  static const Color _darkCardSurface = Color(0xFF1E1E1E);

  // Custom brand colors (LIGHT mode )
  static const _lightColors = AppColorsExtension(
    primaryBlue: Color(0xFF005CE3),
    lightBlue: Color(0xFF2886F8),
    white: Color(0xFFFFFFFF),
    black: Color(0xFF000000),
    offWhite: Color(0xFFFAF9F6),
    cream: Color(0xFFFDF6EC),
    reacher: Color(0xFFC7DEFA),
    hintColor: Color(0xFF94A3B8),
  );

  // Custom brand colors ( DARK mode )
  static const _darkColors = AppColorsExtension(
    primaryBlue: Color(0xFF4B9BFF),
    lightBlue: Color(0xFF6FA8F5),
    white: Color(0xFF000000), 
    black: Color(0xFFFFFFFF),
    offWhite: Color(0xFF1E1E1E),
    cream: Color(0xFF2A2622),
    reacher: Color(0xFF1B3A5C),
    hintColor: Color(0xFF64748B),
  );

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
      primary: _primary,
      surface: _lightSurface,
      error: _error,
    );
    return _base(scheme, _lightColors);
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
      primary: _primary,
      surface: _darkSurface,
      surfaceContainerHighest: _darkCardSurface,
      error: _error,
    );
    return _base(scheme, _darkColors);
  }

  static ThemeData _base(ColorScheme scheme, AppColorsExtension appColors) {
    final isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: scheme.primary.withOpacity(0.4),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: scheme.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : scheme.primary.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      extensions: [appColors],
    );
  }
}