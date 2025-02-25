import 'package:flutter/material.dart';

class AppTheme {
  static const double _borderRadius = 12.0;
  static const Color primaryColor = Colors.lightBlue;
  static const Color secondaryColor = Color(0xFF2f6d80); // light maroon
  static const Color tertiaryColor = Color(0xFF6aa4b0); // light maroon

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      brightness: Brightness.light,
    ),

    // Input decoration theme for text fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primaryColor.withValues(alpha: 0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: secondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
    ),

    // Navigation bar theme
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: primaryColor.withValues(alpha: 0.1),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
        }
        return const TextStyle(fontSize: 12);
      }),
    ),

    // App bar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: primaryColor.withValues(alpha: 0.1),
      elevation: 0,
      titleTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
    ),
  );
}
