import 'package:flutter/material.dart';

/// Spacing, border radiuses, and blur intensities for Liquid Glass.
class AppDimensions {
  AppDimensions._();

  // Glass Blur Sigmas
  static const double blurSubtle = 8.0;
  static const double blurStandard = 16.0;
  static const double blurHeavy = 24.0;
  static const double blurUltra = 32.0;

  // Border Radii
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 18.0;
  static const double radiusLarge = 24.0;
  static const double radiusExtraLarge = 32.0;
  static const double radiusPill = 999.0;

  static final BorderRadius borderRadiusSmall = BorderRadius.circular(radiusSmall);
  static final BorderRadius borderRadiusMedium = BorderRadius.circular(radiusMedium);
  static final BorderRadius borderRadiusLarge = BorderRadius.circular(radiusLarge);
  static final BorderRadius borderRadiusExtraLarge = BorderRadius.circular(radiusExtraLarge);
  static final BorderRadius borderRadiusPill = BorderRadius.circular(radiusPill);

  // Spacing
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;

  // Layout Breakpoints
  static const double mobileBreakpoint = 650.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // Component Heights
  static const double buttonHeight = 52.0;
  static const double inputHeight = 54.0;
  static const double navBarHeight = 72.0;
  static const double topBarHeight = 70.0;
  static const double sidebarWidth = 260.0;
}
