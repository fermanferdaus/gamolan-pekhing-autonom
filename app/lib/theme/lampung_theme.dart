import 'package:flutter/material.dart';

/// Flat Modern Theme — 2 Warna Utama: Putih dan Biru (Royal Blue)
/// Sesuai panduan desain.md: flat murni, tanpa gradient, tanpa blur/glow, hard offset shadow, pill buttons.
class LampungTheme {
  LampungTheme._();

  // --- Palet Utama 1: Biru (Royal Blue Family) ---
  static const Color primaryBlue = Color(0xFF2563EB); // bg-blue-600 (primer, tombol utama, aksen)
  static const Color secondaryBlue = Color(0xFF1D4ED8); // bg-blue-700 (band sekunder, ticker/CTA)
  static const Color darkBlue = Color(0xFF1E40AF); // blue-800 (hard shadow & aksen tebal)
  static const Color deepBlue = Color(0xFF1E3A8A); // blue-900 (hard shadow tombol primer)
  static const Color accentBlueLight = Color(0xFFDBEAFE); // blue-100 (aksen latar & border halus)
  static const Color accentBlueHighlight = Color(0xFFBFDBFE); // blue-200 (highlight teks & border aktif)
  static const Color blue50 = Color(0xFFEFF6FF); // blue-50 (latar aktif kartu & container)

  // --- Palet Utama 2: Putih & Netral Terang (White & Clean Slate) ---
  static const Color bgWhite = Color(0xFFFFFFFF); // Putih Murni (Latar utama aplikasi)
  static const Color slate50 = Color(0xFFF8FAFC); // Putih gading / slate sangat terang
  static const Color slate100 = Color(0xFFF1F5F9); // Slate-100
  static const Color slate200 = Color(0xFFE2E8F0); // Border slate standar
  static const Color slate300 = Color(0xFFCBD5E1); // Border sekunder
  static const Color slate400 = Color(0xFF94A3B8); // Text slate muted
  static const Color slate500 = Color(0xFF64748B); // Text slate sekunder
  static const Color slate600 = Color(0xFF475569); // Text slate bodi
  static const Color slate700 = Color(0xFF334155); // Text slate gelap
  static const Color slate800 = Color(0xFF1E293B); // Slate-800
  static const Color slate900 = Color(0xFF0F172A); // Text slate utama
  static const Color slate950 = Color(0xFF020617); // Slate-950

  // --- Status Flat (Fungsional) ---
  static const Color statusSuccess = Color(0xFF16A34A); // green-600
  static const Color statusDanger = Color(0xFFDC2626); // red-600
  static const Color statusWarning = Color(0xFFD97706); // amber-600

  // --- Aliases untuk backward compatibility ---
  static const Color bgDark = bgWhite;
  static const Color bgMedium = slate50;
  static const Color bgCard = bgWhite;
  static const Color bgSurface = blue50;
  static const Color bgBorder = slate200;

  static const Color gold = primaryBlue;
  static const Color goldLight = accentBlueLight;
  static const Color goldDark = secondaryBlue;
  static const Color goldBronze = darkBlue;
  static const Color goldGlow = accentBlueHighlight;

  static const Color tapisRed = statusDanger;
  static const Color tapisCrimson = Color(0xFFB91C1C);
  static const Color tapisDark = Color(0xFF7F1D1D);

  static const Color bambooLight = bgWhite;
  static const Color bambooMid = blue50;
  static const Color bambooDark = slate200;

  static const Color textPrimary = slate900;
  static const Color textSecondary = slate600;
  static const Color textMuted = slate500;
  static const Color textGold = primaryBlue;

  // --- Hard Offset Shadow (tanpa blur, pengganti bayangan blur sesuai desain.md) ---
  static const List<BoxShadow> hardShadowPill = [
    BoxShadow(
      color: deepBlue,
      offset: Offset(2, 3),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> hardShadowCard = [
    BoxShadow(
      color: Color(0x1F1D4ED8), // rgba(29,78,216,0.12)
      offset: Offset(3, 3),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> hardShadowCardHover = [
    BoxShadow(
      color: darkBlue,
      offset: Offset(3, 3),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> hardShadowDark = [
    BoxShadow(
      color: secondaryBlue,
      offset: Offset(2, 2),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: bgWhite,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: secondaryBlue,
        surface: bgWhite,
        onPrimary: bgWhite,
        onSecondary: bgWhite,
        onSurface: slate900,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgWhite,
        foregroundColor: primaryBlue,
        elevation: 0,
      ),
      fontFamily: 'Segoe UI',
    );
  }

  // Alias untuk main.dart
  static ThemeData get darkTheme => lightTheme;
}
