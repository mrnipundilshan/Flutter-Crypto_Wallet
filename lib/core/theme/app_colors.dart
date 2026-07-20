import 'package:flutter/material.dart';

/// Centralized color palette for the app, with light and dark variants.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF8E7CF7);
  static const Color primaryDark = Color(0xFF5142C4);

  // Status
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);

  // Light theme surfaces
  static const Color backgroundLight = Color(0xFFF7F7FB);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF0EEFA);
  static const Color borderLight = Color(0xFFE4E1F5);
  static const Color textPrimaryLight = Color(0xFF1B1B23);
  static const Color textSecondaryLight = Color(0xFF6E6E80);

  // Dark theme surfaces
  static const Color backgroundDark = Color(0xFF13121A);
  static const Color surfaceDark = Color(0xFF1D1C27);
  static const Color surfaceVariantDark = Color(0xFF252433);
  static const Color borderDark = Color(0xFF322F45);
  static const Color textPrimaryDark = Color(0xFFF2F1F8);
  static const Color textSecondaryDark = Color(0xFFA5A3B8);

  static const Color warningBackgroundLight = Color(0xFFFDF3E0);
  static const Color warningBackgroundDark = Color(0xFF3A2F14);
}
