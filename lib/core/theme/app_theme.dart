import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFF39C12);
  static const Color primaryBackground = Color(0xFFF5F6FA);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFF7F8C8D);
  static const Color successGreen = Color(0xFF27AE60);
  static const Color alertRed = Color(0xFFE74C3C);
  static const Color cardBackground = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryOrange,
      scaffoldBackgroundColor: primaryBackground,
      colorScheme: const ColorScheme.light(
        primary: primaryOrange,
        secondary: Color(0xFFE67E22),
        background: primaryBackground,
        error: alertRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryOrange,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white, size: 32),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: textDark),
        displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textDark),
        bodyLarge: TextStyle(fontSize: 24, color: textDark),
        bodyMedium: TextStyle(fontSize: 20, color: textDark),
        labelLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
      ),
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      iconTheme: const IconThemeData(
        size: 40,
        color: primaryOrange,
      ),
    );
  }
}
