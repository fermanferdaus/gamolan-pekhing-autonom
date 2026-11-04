import 'package:flutter/material.dart';

/// Flat Modern Theme — Royal Blue & Slate Design System (per desain.md)
/// Flat murni: tanpa gradient, tanpa blur/glow, hard offset shadow, pill buttons.
class LampungTheme {
  LampungTheme._();

  // --- Palet Royal Blue (desain.md) ---
  static const Color primaryBlue = Color(0xFF2563EB); // bg-blue-600 (primer seksi, tombol utama)
  static const Color secondaryBlue = Color(0xFF1D4ED8); // bg-blue-700 (band sekunder, ticker/CTA)
  static const Color darkBlue = Color(0xFF1E40AF); // blue-800 (hard shadow & aksen tebal)
  static const Color deepBlue = Color(0xFF1E3A8A); // blue-900 (hard shadow tombol primer)
  static const Color accentBlueLight = Color(0xFFDBEAFE); // blue-100 (aksen teks di seksi biru)
  static const Color accentBlueHighlight = Color(0xFFBFDBFE); // blue-200 (highlight teks)
  static const Color blue50 = Color(0xFFEFF6FF); // blue-50 (latar aktif kartu)

  // --- Palet Slate Neutrals (desain.md) ---
  static const Color slate50 = Color(0xFFF8FAFC); // bg-slate-50 (latar bergantian)
  static const Color slate100 = Color(0xFFF1F5F9); // bg-slate-100
  static const Color slate200 = Color(0xFFE2E8F0); // border-slate-200 (border standar kartu)
  static const Color slate300 = Color(0xFFCBD5E1); // border-slate-300
  static const Color slate400 = Color(0xFF94A3B8); // text-slate-400 (label meta)
  static const Color slate500 = Color(0xFF64748B); // text-slate-500 (muted)
  static const Color slate600 = Color(0xFF475569); // text-slate-600 (sekunder)
  static const Color slate700 = Color(0xFF334155); // border gelap / teks
  static const Color slate800 = Color(0xFF1E293B); // slate-800
  static const Color slate900 = Color(0xFF0F172A); // text-slate-900 (utama)
  static const Color slate950 = Color(0xFF020617); // bg-slate-950 (top bar, footer, kartu status)
  static const Color bgWhite = Color(0xFFFFFFFF); // bg-white

  // --- Status Flat ---
  static const Color statusSuccess = Color(0xFF16A34A); // green-600
  static const Color statusDanger = Color(0xFFDC2626); // red-600
  static const Color statusWarning = Color(0xFFD97706); // amber-600

  // --- Aliases untuk backward compatibility ---
  static const Color bgDark = slate950;
  static const Color bgMedium = slate900;
  static const Color bgCard = bgWhite;
  static const Color bgSurface = slate100;
  static const Color bgBorder = slate200;

  static const Color gold = primaryBlue;
  static const Color goldLight = accentBlueLight;
  static const Color goldDark = secondaryBlue;
  static const Color goldBronze = darkBlue;
  static const Color goldGlow = accentBlueHighlight;

  static const Color tapisRed = statusDanger;
  static const Color tapisCrimson = Color(0xFFB91C1C);
  static const Color tapisDark = Color(0xFF7F1D1D);

  static const Color bambooLight = slate100;
  static const Color bambooMid = slate200;
  static const Color bambooDark = slate300;

  static const Color textPrimary = slate900;
  static const Color textSecondary = slate600;
  static const Color textMuted = slate500;
  static const Color textGold = primaryBlue;

  // --- Hard Offset Shadow (tanpa blur, pengganti bayangan blur sesuai desain.md) ---
  static const List<BoxShadow> hardShadowPill = [
    BoxShadow(
      color: deepBlue,
      offset: Offset(3, 4),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> hardShadowCard = [
    BoxShadow(
      color: Color(0x1F1D4ED8), // rgba(29,78,216,0.12)
      offset: Offset(4, 4),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> hardShadowCardHover = [
    BoxShadow(
      color: darkBlue,
      offset: Offset(4, 4),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> hardShadowDark = [
    BoxShadow(
      color: secondaryBlue,
      offset: Offset(3, 3),
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: slate50,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: secondaryBlue,
        surface: bgWhite,
        onPrimary: bgWhite,
        onSecondary: bgWhite,
        onSurface: slate900,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: slate950,
        foregroundColor: bgWhite,
        elevation: 0,
      ),
      fontFamily: 'Segoe UI',
    );
  }

  // Alias untuk main.dart
  static ThemeData get darkTheme => lightTheme;
}
