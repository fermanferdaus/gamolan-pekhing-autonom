import 'package:flutter/material.dart';

class LampungTheme {
  LampungTheme._();

  // Dasar Gelap Modern (Obsidian Charcoal - Elegan & Kontras Tinggi)
  static const Color bgDark = Color(0xFF0F1117);
  static const Color bgMedium = Color(0xFF161922);
  static const Color bgCard = Color(0xFF1E222E);
  static const Color bgSurface = Color(0xFF282D3D);
  static const Color bgBorder = Color(0xFF353C4F);

  // Emas Adat Lampung (Siger & Benang Emas Tapis)
  static const Color gold = Color(0xFFE5B842);
  static const Color goldLight = Color(0xFFFFE599);
  static const Color goldDark = Color(0xFFB3861B);
  static const Color goldGlow = Color(0xFFFFF0B8);
  static const Color goldBronze = Color(0xFFC99B3B);

  // Merah Tapis Lampung (Kain Tapis Inuh / Jung Sarat)
  static const Color tapisRed = Color(0xFFC02A3E);
  static const Color tapisCrimson = Color(0xFF9E1B2D);
  static const Color tapisDark = Color(0xFF5A0E1A);

  // Bilah Bambu Gamolan
  static const Color bambooLight = Color(0xFFF0D593);
  static const Color bambooMid = Color(0xFFD8B058);
  static const Color bambooDark = Color(0xFFA88028);

  // Tipografi
  static const Color textPrimary = Color(0xFFF7F8FA);
  static const Color textSecondary = Color(0xFFD1D6E2);
  static const Color textMuted = Color(0xFF868E9F);
  static const Color textGold = Color(0xFFFFE082);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: gold,
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: tapisRed,
        surface: bgCard,
        onPrimary: bgDark,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgMedium,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      fontFamily: 'Segoe UI',
    );
  }
}
