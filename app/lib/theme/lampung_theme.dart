import 'package:flutter/material.dart';

class LampungTheme {
  LampungTheme._();

  // Warna utama dari kain tapis & siger Lampung
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFFFF099);
  static const Color goldDark = Color(0xFF8B6914);
  static const Color goldBronze = Color(0xFFC5A059);

  // Warna kain tapis Lampung (merah marun gelap)
  static const Color tapisDark = Color(0xFF3B0A0A);
  static const Color tapisMaroon = Color(0xFF5C1414);
  static const Color tapisRed = Color(0xFF8B2020);

  // Background gelap nuansa kayu/bambu
  static const Color bgDark = Color(0xFF1A1209);
  static const Color bgMedium = Color(0xFF251D10);
  static const Color bgCard = Color(0xFF2A2014);
  static const Color bgSurface = Color(0xFF32281A);

  // Aksen
  static const Color textPrimary = Color(0xFFF5E6C8);
  static const Color textSecondary = Color(0xFFBFA87A);
  static const Color textMuted = Color(0xFF7A6B50);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: gold,
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: tapisMaroon,
        surface: bgCard,
        onPrimary: Color(0xFF1A1209),
        onSecondary: textPrimary,
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
