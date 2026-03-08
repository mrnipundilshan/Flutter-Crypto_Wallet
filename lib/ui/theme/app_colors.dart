import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary Gradient ──
  static const Color deepIndigo = Color(0xFF1A1A2E);
  static const Color charcoal = Color(0xFF16213E);
  static const Color midnightBlue = Color(0xFF0F3460);

  // ── Neon Accents ──
  static const Color neonGreen = Color(0xFF00FFA3);
  static const Color neonCyan = Color(0xFF00D2FF);
  static const Color neonPurple = Color(0xFFBB86FC);
  static const Color neonPink = Color(0xFFFF006E);

  // ── Glass Surface ──
  static const Color glassFill = Color(0x1AFFFFFF); // 10% white
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white
  static const Color glassHighlight = Color(0x0DFFFFFF); // 5% white

  // ── Text ──
  static const Color textPrimary = Color(0xFFF0F0F0);
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% white
  static const Color textMuted = Color(0x80FFFFFF); // 50% white

  // ── Status ──
  static const Color positive = Color(0xFF00E676);
  static const Color negative = Color(0xFFFF5252);

  // ── Background gradient ──
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepIndigo, charcoal, Color(0xFF0D1B2A)],
    stops: [0.0, 0.5, 1.0],
  );

  // ── Neon button gradient ──
  static const LinearGradient neonGradient = LinearGradient(
    colors: [neonGreen, neonCyan],
  );

  static const LinearGradient neonPurpleGradient = LinearGradient(
    colors: [neonPurple, neonCyan],
  );
}
