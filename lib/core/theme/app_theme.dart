import 'package:flutter/material.dart';

class AppTheme {
  // Dobapp brand colors
  static const Color background = Color(0xFF08080B);
  static const Color surface = Color(0xFF111117);
  static const Color surfaceLight = Color(0xFF191922);

  static const Color primary = Color(0xFF9B6CFF);
  static const Color primaryDark = Color(0xFF6E3FD9);

  static const Color textPrimary = Color(0xFFF5F3FA);
  static const Color textSecondary = Color(0xFF9A98A5);

  static const Color divider = Color(0xFF25232D);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: primary,
      surface: surface,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
      ),
    ),

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xFF0D0D12),
      indicatorColor: Color(0x339B6CFF),
      elevation: 0,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      hintStyle: const TextStyle(
        color: textSecondary,
      ),
      prefixIconColor: textSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: primary,
          width: 1.2,
        ),
      ),
    ),

    iconTheme: const IconThemeData(
      color: textPrimary,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.w800,
      ),
      headlineMedium: TextStyle(
        color: textPrimary,
        fontSize: 26,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: textPrimary,
        fontSize: 21,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: textSecondary,
        fontSize: 14,
      ),
    ),
  );
}