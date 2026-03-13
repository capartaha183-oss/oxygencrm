import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color bg = Color(0xFF080C10);
  static const Color surface = Color(0xFF0D1117);
  static const Color card = Color(0xFF111820);
  static const Color border = Color(0xFF1E2D3D);
  static const Color accent = Color(0xFF00D4FF);
  static const Color accentGreen = Color(0xFF00FF88);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentRed = Color(0xFFFF3B5C);
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF7D8590);
  static const Color textMuted = Color(0xFF3D4E5E);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: accent,
        secondary: accentGreen,
        error: accentRed,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.jetBrainsMono(
          color: textPrimary,
          fontSize: 14,
        ),
        bodyMedium: GoogleFonts.jetBrainsMono(
          color: textSecondary,
          fontSize: 13,
        ),
      ),
      dividerColor: border,
      cardColor: card,
    );
  }
}
