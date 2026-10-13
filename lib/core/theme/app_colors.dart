import 'package:flutter/material.dart';

/// Design tokens and curated color palette for MyBMI.
/// White is the dominant primary color with restrained, sophisticated green accents.
class AppColors {
  AppColors._();

  // Primary backgrounds & surfaces
  static const Color primaryBackground = Color(0xFFFFFFFF);
  static const Color secondaryBackground = Color(0xFFF7F9F7);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF2F5F2);

  // Brand Green Accents
  static const Color primaryGreen = Color(0xFF237A57);
  static const Color darkGreen = Color(0xFF185C41);
  static const Color softGreen = Color(0xFFE8F4EC);
  static const Color lightGreenTint = Color(0xFFF0F8F3);

  // Typography & Text
  static const Color primaryText = Color(0xFF17211C);
  static const Color secondaryText = Color(0xFF6B756F);
  static const Color mutedText = Color(0xFF9AA39E);

  // Borders & Dividers
  static const Color border = Color(0xFFE8EDE9);
  static const Color borderSubtle = Color(0xFFF0F3F0);
  static const Color borderFocus = Color(0xFF237A57);

  // Functional & Semantic Feedback
  static const Color error = Color(0xFFC0392B);
  static const Color errorLight = Color(0xFFFDEDEC);
  static const Color warning = Color(0xFFB7791F);
  static const Color warningLight = Color(0xFFFEF9E7);
  static const Color info = Color(0xFF2B7A78);
  static const Color infoLight = Color(0xFFE6F3F3);

  // BMI Category Specific Accents (scientifically balanced, professional)
  static const Color bmiUnderweight = Color(0xFF2E86AB); // Clear informative steel blue
  static const Color bmiHealthy = Color(0xFF237A57);     // Primary emerald green
  static const Color bmiOverweight = Color(0xFFD97706);  // Warm amber
  static const Color bmiObese1 = Color(0xFFE65100);      // Deep amber/orange
  static const Color bmiObese2 = Color(0xFFC0392B);      // Crimson red
  static const Color bmiObese3 = Color(0xFF881337);      // Dark wine red

  // Dark Theme Counterparts (if user enables dark theme)
  static const Color darkBackground = Color(0xFF111613);
  static const Color darkSurface = Color(0xFF1A221E);
  static const Color darkSurfaceSubtle = Color(0xFF232E28);
  static const Color darkBorder = Color(0xFF2B3A32);
  static const Color darkPrimaryText = Color(0xFFF2F6F3);
  static const Color darkSecondaryText = Color(0xFFA1ADA5);
}
