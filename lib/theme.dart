import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF0B1020);
  static const card = Color(0xFF1B2333);
  static const sheet = Color(0xFF1F2937);
  static const input = Color(0xFF111827);
  static const border = Color(0xFF2A3447);
  static const accent = Color(0xFFFBBF24);
  static const accentText = Color(0xFF1A1305);
  static const text = Color(0xFFFFFFFF);
  static const muted = Color(0xFF8B95A7);
  static const success = Color(0xFF34D399);
  static const danger = Color(0xFFF87171);
}

class AppRadius {
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 20.0;
  static const xl = 28.0;
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.accentText,
      surface: AppColors.sheet,
      onSurface: AppColors.text,
      error: AppColors.danger,
    ),
    splashFactory: InkRipple.splashFactory,
  );
}
