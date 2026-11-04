import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Deep Black Dark Mode (Default) ───
  static const Color backgroundDark = Color(0xFF05070A);
  static const Color cardDark = Color(0xFF10141B);
  static const Color elevatedDark = Color(0xFF171C26);
  static const Color surfaceDark = Color(0xFF10141B);
  static const Color borderDark = Color(0x12FFFFFF); // rgba(255, 255, 255, 0.07)
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color mutedDark = Color(0xFF64748B);

  // ─── Daylight White Mode ───
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color elevatedLight = Color(0xFFF1F5F9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0x140F172A); // rgba(15, 23, 42, 0.08)
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color mutedLight = Color(0xFF94A3B8);

  // ─── Shared Accent ───
  static const Color accent = Color(0xFFB8F624);          // Primary Lime
  static const Color primary = Color(0xFFB8F624);         // Alias for accent
  static const Color primaryAccent = Color(0xFFB8F624);   // Alias
  static const Color primaryButton = Color(0xFFB8F624);   // Primary Button Fill
  static const Color primaryLight = Color(0xFFF1F8E1);     // Soft pale lime
  static const Color primaryLightDark = Color(0xFF1B2810); // Dim accent container (dark)
  static const Color primaryBorder = Color(0x33B8F624);
  static const Color onAccent = Color(0xFF090D02);         // Text on accent
  static const Color accentDim = Color(0xFF1B2810);        // Dim accent container (dark)
  static const Color accentTextLight = Color(0xFF4D7C0F);  // Forest green for white surfaces

  // ─── Status ───
  static const Color info = Color(0xFF38BDF8);             // Sky blue
  static const Color secondary = Color(0xFF38BDF8);        // Alias for info
  static const Color secondaryLight = Color(0xFFE0F2FE);
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFF43F5E);
  static const Color errorLight = Color(0xFFFFE4E6);

  // ─── BMI 4-Zone Spectrum ───
  static const Color bmiUnderweight = Color(0xFF06B6D4);   // Cyan-Blue
  static const Color bmiHealthy = Color(0xFF10B981);       // Lime-Emerald
  static const Color bmiOverweight = Color(0xFFF59E0B);    // Amber-Orange
  static const Color bmiObese = Color(0xFFF43F5E);         // Coral-Rose

  // ─── Convenience Semantic Resolvers ───
  static Color card(bool isDark) => isDark ? cardDark : cardLight;
  static Color background(bool isDark) => isDark ? backgroundDark : backgroundLight;
  static Color elevated(bool isDark) => isDark ? elevatedDark : elevatedLight;
  static Color border(bool isDark) => isDark ? borderDark : borderLight;
  static Color textPrimary(bool isDark) => isDark ? textPrimaryDark : textPrimaryLight;
  static Color textSecondary(bool isDark) => isDark ? textSecondaryDark : textSecondaryLight;
  static Color muted(bool isDark) => isDark ? mutedDark : mutedLight;
}
