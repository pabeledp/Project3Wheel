import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Utilities and ThemeData setup for Liquid Glass styling.
class GlassTheme {
  GlassTheme._();

  /// Standard translucent glass box decoration with specular gradient border
  static BoxDecoration glassDecoration({
    Color? color,
    BorderRadius? borderRadius,
    Gradient? borderGradient,
    double borderWidth = 1.0,
    List<BoxShadow>? shadows,
    Gradient? fillGradient,
  }) {
    return BoxDecoration(
      color: fillGradient == null ? (color ?? AppColors.glassWhiteLight) : null,
      gradient: fillGradient,
      borderRadius: borderRadius ?? AppDimensions.borderRadiusLarge,
      border: Border.all(
        color: Colors.white.withOpacity(0.18),
        width: borderWidth,
      ),
      boxShadow: shadows ?? [
        BoxShadow(
          color: Colors.black.withOpacity(0.35),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: -4,
        ),
      ],
    );
  }

  /// High-gloss card decoration with specular reflection
  static BoxDecoration glossCardDecoration({
    Color? accentGlowColor,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: AppColors.glassWhiteLight,
      borderRadius: borderRadius ?? AppDimensions.borderRadiusLarge,
      border: Border.all(
        color: (accentGlowColor ?? Colors.white).withOpacity(0.22),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: (accentGlowColor ?? Colors.black).withOpacity(0.2),
          blurRadius: 28,
          offset: const Offset(0, 10),
          spreadRadius: -6,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// App ThemeData configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.primaryBlue,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        secondary: AppColors.primaryPurple,
        surface: AppColors.backgroundCard,
        error: AppColors.crimsonRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      splashColor: AppColors.primaryBlue.withOpacity(0.15),
      highlightColor: Colors.transparent,
    );
  }
}
