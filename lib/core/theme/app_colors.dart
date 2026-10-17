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

  // Dark Theme Counterparts (deep obsidian sleek dark palette)
  static const Color darkBackground = Color(0xFF0F1412);
  static const Color darkSurface = Color(0xFF171D1A);
  static const Color darkSurfaceSubtle = Color(0xFF202723);
  static const Color darkBorder = Color(0xFF2C3631);
  static const Color darkBorderSubtle = Color(0xFF232B27);
  static const Color darkPrimaryText = Color(0xFFF3F7F5);
  static const Color darkSecondaryText = Color(0xFFA2ADA7);
  static const Color darkMutedText = Color(0xFF6F7B74);

  // Vibrant Brand Accents for Dark Theme
  static const Color primaryGreenDark = Color(0xFF2EB872);
  static const Color darkGreenAccent = Color(0xFF144D34);
  static const Color softGreenDark = Color(0xFF1B3327);

  // Semantic Dark Feedback
  static const Color errorDark = Color(0xFF381B1B);
  static const Color warningDark = Color(0xFF352712);
  static const Color infoDark = Color(0xFF122C30);
}
