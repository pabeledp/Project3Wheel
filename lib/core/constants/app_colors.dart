import 'package:flutter/material.dart';

/// Design tokens for Apple's Liquid Glass UI system.
class AppColors {
  AppColors._();

  // Deep Space Backgrounds
  static const Color backgroundDark = Color(0xFF0B0E14);
  static const Color backgroundCard = Color(0xFF141923);
  static const Color backgroundElevated = Color(0xFF1C2331);

  // Liquid Glass Fills (Translucency)
  static const Color glassWhiteUltraLight = Color(0x0DFFFFFF); // ~5%
  static const Color glassWhiteLight = Color(0x1AFFFFFF);      // ~10%
  static const Color glassWhiteMedium = Color(0x28FFFFFF);     // ~16%
  static const Color glassWhiteStrong = Color(0x40FFFFFF);     // ~25%

  static const Color glassDarkLight = Color(0x33000000);       // ~20%
  static const Color glassDarkMedium = Color(0x660B0E14);      // ~40%
  static const Color glassDarkStrong = Color(0x990B0E14);      // ~60%

  // Specular Border Colors
  static const Color specularBorderLight = Color(0x4DFFFFFF);  // 30% white
  static const Color specularBorderDim = Color(0x1AFFFFFF);    // 10% white
  static const Color specularBorderActive = Color(0x800A84FF); // 50% system blue

  // Liquid Accent Colors (iOS vibrant system hues)
  static const Color primaryBlue = Color(0xFF0A84FF);
  static const Color primaryPurple = Color(0xFF5E5CE6);
  static const Color primaryIndigo = Color(0xFF5856D6);
  static const Color accentCyan = Color(0xFF64D2FF);
  static const Color accentTeal = Color(0xFF40C8E0);

  // Financial & Operational State Accents
  static const Color emeraldGreen = Color(0xFF10B981);  // Income / Paid / Online
  static const Color emeraldGreenLight = Color(0xFF34D399);
  static const Color crimsonRed = Color(0xFFFF3B30);    // Expense / Defaulter / Error
  static const Color crimsonRedLight = Color(0xFFFF6961);
  static const Color electricAmber = Color(0xFFFF9500);  // Due / Partial / Pending Sync
  static const Color electricAmberLight = Color(0xFFFFB340);

  // Neutral Text & Icons
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF98989F);
  static const Color textTertiary = Color(0xFF636366);
  static const Color textMuted = Color(0xFF48484A);

  // Liquid Pastel Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A84FF), Color(0xFF5E5CE6)],
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  static const LinearGradient crimsonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF453A), Color(0xFFFF3B30)],
  );

  static const LinearGradient amberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9F0A), Color(0xFFFF8500)],
  );

  static const LinearGradient specularBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x59FFFFFF), // 35%
      Color(0x1AFFFFFF), // 10%
      Color(0x08FFFFFF), // 3%
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient activeBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A84FF),
      Color(0xFF5E5CE6),
      Color(0x330A84FF),
    ],
  );

  static const RadialGradient backgroundGlowBlue = RadialGradient(
    center: Alignment(-0.8, -0.6),
    radius: 1.2,
    colors: [
      Color(0x2E0A84FF),
      Color(0x000B0E14),
    ],
  );

  static const RadialGradient backgroundGlowPurple = RadialGradient(
    center: Alignment(0.9, 0.7),
    radius: 1.4,
    colors: [
      Color(0x265E5CE6),
      Color(0x000B0E14),
    ],
  );

  static const RadialGradient backgroundGlowEmerald = RadialGradient(
    center: Alignment(0.0, -0.3),
    radius: 0.8,
    colors: [
      Color(0x2010B981),
      Color(0x000B0E14),
    ],
  );
}
