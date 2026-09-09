import 'package:flutter/material.dart';

// COLOR EXTENSION

extension ColorXContext on BuildContext {
  
  // THEME
  ThemeData get theme => Theme.of(this);
  ColorScheme get cs => theme.colorScheme;

  
  // THEME COLORS
  // These colors come from ThemeData / ColorScheme
  
  Color get primary => cs.primary;
  Color get onPrimary => cs.onPrimary;
  Color get secondary => cs.secondary;
  Color get onSecondary => cs.onSecondary;
  Color get surface => cs.surface;
  Color get onSurface => cs.onSurface;
  Color get background => cs.surface;
  Color get onBackground => cs.onSurface;
  Color get error => cs.error;
  Color get onError => cs.onError;


  // AUTO TEXT COLOR
  
  Color onColor(Color color) {
    return color.computeLuminance() < 0.5 ? white : black;
  }
  Color get textPrimary => onColor(primary);
  Color get textSecondary => onColor(surface);

  
  // CUSTOM APP COLORS
 
  Color get primaryBlue => const Color(0xFF005CE3);

  Color get lightBlue => const Color(0xFF2886F8);

  Color get white => const Color(0xFFFFFFFF);

  Color get black => const Color(0xFF000000);

  Color get offWhite => const Color(0xFFFAF9F6);

  Color get cream => const Color(0xFFFDF6EC);

  Color get reacher => const Color(0xFFC7DEFA);

  Color get hintColor => const Color(0xFF94A3B8);

  Color get transparentColor => const Color(0x00000000);
}


/// TEXT STYLE EXTENSION

extension TextStyleXContext on BuildContext {
  
  // RESPONSIVE SCALE
  
  double get _scale {
    final width = MediaQuery.of(this).size.width;

    return (width / 375).clamp(0.85, 1.2);
  }


  // THEME TEXT


  TextTheme get _t => Theme.of(this).textTheme;

  // BASE TEXT STYLE


  TextStyle _base(
    TextStyle? style, {
    double size = 14,
    FontWeight weight = FontWeight.w400,
    double letter = -0.2,
    double height = 1.3,
    Color? color,
  }) {
    return (style ?? const TextStyle()).copyWith(
      fontSize: size * _scale,
      fontWeight: weight,
      letterSpacing: letter,
      height: height,
      color: color,
    );
  }

  // HEADLINE
 
  TextStyle get headlineLarge => _base(
        _t.headlineLarge,
        size: 34,
        weight: FontWeight.w800,
        letter: -1,
      );

  TextStyle get headlineML => _base(
        _t.headlineMedium,
        size: 30,
        weight: FontWeight.w700,
      );

  TextStyle get headlineSL => _base(
        _t.headlineSmall,
        size: 26,
        weight: FontWeight.w700,
      );

   // BODY
 
  TextStyle get bodyLR => _base(
        _t.bodyLarge,
        size: 24,
        weight: FontWeight.w400,
      );

  TextStyle get bodyMR => _base(
        _t.bodyMedium,
        size: 22,
        weight: FontWeight.w400,
      );

  TextStyle get bodyMB => _base(
        _t.bodyMedium,
        size: 18,
        weight: FontWeight.w600,
      );

  TextStyle get bodySSB => _base(
        _t.bodySmall,
        size: 16,
        weight: FontWeight.w400,
      );

   // TITLE
 
  TextStyle get titleLR => _base(
        _t.titleLarge,
        size: 20,
        weight: FontWeight.w500,
      );

  TextStyle get titleMR => _base(
        _t.titleMedium,
        size: 18,
        weight: FontWeight.w600,
      );

  TextStyle get titleSB => _base(
        _t.titleSmall,
        size: 16,
        weight: FontWeight.w600,
      );

  TextStyle get titleSSB => _base(
        _t.titleSmall,
        size: 15,
        weight: FontWeight.w500,
      );

   // LABEL
 
  TextStyle get labelLB => _base(
        _t.labelLarge,
        size: 18,
        weight: FontWeight.w600,
      );

  TextStyle get labelLM => _base(
        _t.labelLarge,
        size: 16,
        weight: FontWeight.w400,
      );

  TextStyle get labelMR => _base(
        _t.labelMedium,
        size: 14,
        weight: FontWeight.w400,
      );

  TextStyle get labelMB => _base(
        _t.labelMedium,
        size: 13,
        weight: FontWeight.w600,
      );

  TextStyle get labelMSB => _base(
        _t.labelMedium,
        size: 12,
        weight: FontWeight.w500,
      );

  TextStyle get labelSM => _base(
        _t.labelSmall,
        size: 11,
        weight: FontWeight.w400,
      );

  TextStyle get labelSB => _base(
        _t.labelSmall,
        size: 10,
        weight: FontWeight.w500,
      );

  TextStyle get labelSR => _base(
        _t.labelSmall,
        size: 11,
        weight: FontWeight.w300,
      );
}