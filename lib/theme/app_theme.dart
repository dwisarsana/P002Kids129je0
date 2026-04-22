import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors for Kids Room AI (Light Theme)
  static const Color mossGreen = Color(0xFFF43F5E); // Rose (Primary)
  static const Color leafGreen = Color(0xFF10B981); // Emerald
  static const Color mintGreen = Color(0xFF8B5CF6); // Purple
  static const Color deepSoil = Color(0xFFE0E0E0); // Lighter gray for elements
  static const Color warmSand = Color(0xFFF8F9FA); // Very light gray background
  static const Color mistWhite = Color(0xFFFFFFFF); // Pure white for cards
  static const Color sunGlow = Color(0xFFFFB74D); // Warm Orange
  static const Color skyBlue = Color(0xFF64B5F6); // Soft Blue
  static const Color roseGold = Color(0xFFE8B4B8);
  static const Color lavender = Color(0xFFB39DDB);
  static const Color coral = Color(0xFFFF8A65);
  static const Color slate = Color(0xFF455A64); // Dark slate for subtitle text
  static const Color charcoal = Color(0xFF1A1A1A); // Almost black for main text
  static const Color cream = Color(0xFFFFF8E1);
  static const Color textLight = Color(0xFF1A1A1A); // Alias for dark text on light bg

  // Gradients for existing widgets compatibility
  static const LinearGradient leafGradient = LinearGradient(
    colors: [leafGreen, skyBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunGradient = LinearGradient(
    colors: [Color(0xAAFFB74D), Color(0x00FFB74D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get theme => ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: warmSand,
        colorScheme: ColorScheme.fromSeed(
          seedColor: mossGreen,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: charcoal,
            letterSpacing: -1.0,
            height: 1.2,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: charcoal,
            letterSpacing: -0.5,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: charcoal,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: charcoal,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: charcoal,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: slate,
            height: 1.4,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: slate,
            letterSpacing: 0.5,
          ),
        ),
        iconTheme: const IconThemeData(
          color: charcoal,
        ),
      );

  // Compatibility alias for lightTheme
  static ThemeData get lightTheme => theme;
}
