import 'package:flutter/material.dart';

/// All colors used in the app.
/// Dark theme is default.
class AppColors {
  AppColors._();

  // ==================== PRIMARY GRADIENT ====================
  static const Color primaryStart = Color(0xFF7B5CFF); // Purple
  static const Color primaryMid = Color(0xFF9B6DFF);
  static const Color primaryEnd = Color(0xFF00D4FF); // Cyan

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryStart, primaryMid, primaryEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFFFF4ECD), Color(0xFF7B5CFF), Color(0xFF00D4FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ==================== DARK THEME ====================
  static const Color darkBackground = Color(0xFF0A0B1E);
  static const Color darkSurface = Color(0xFF12132A);
  static const Color darkCard = Color(0xFF1A1B35);
  static const Color darkGlass = Color(0xFF1E1F3A);
  static const Color darkBorder = Color(0xFF2A2B4A);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B3C8);
  static const Color darkTextTertiary = Color(0xFF7A7D9A);

  // ==================== LIGHT THEME ====================
  static const Color lightBackground = Color(0xFFF5F7FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF0F2FF);
  static const Color lightGlass = Color(0xFFE8EBFF);
  static const Color lightBorder = Color(0xFFD0D4F0);
  static const Color lightTextPrimary = Color(0xFF1A1B35);
  static const Color lightTextSecondary = Color(0xFF5A5D7A);
  static const Color lightTextTertiary = Color(0xFF8A8DAB);

  // ==================== ACCENT / STATUS ====================
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF4757);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF00D4FF);

  // ==================== GLOW COLORS ====================
  static const Color glowPurple = Color(0xFF7B5CFF);
  static const Color glowCyan = Color(0xFF00D4FF);
  static const Color glowPink = Color(0xFFFF4ECD);
  static const Color glowBlue = Color(0xFF4A7CFF);

  // ==================== GLASS ====================
  static Color glassDark = Colors.white.withValues(alpha: 0.08);
  static Color glassLight = Colors.white.withValues(alpha: 0.55);
  static Color glassBorderDark = Colors.white.withValues(alpha: 0.15);
  static Color glassBorderLight = Colors.white.withValues(alpha: 0.4);
}
