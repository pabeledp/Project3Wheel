import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < AppDimensions.mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppDimensions.mobileBreakpoint &&
      MediaQuery.of(context).size.width < AppDimensions.tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppDimensions.tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppDimensions.tabletBreakpoint) {
          return desktop;
        } else if (constraints.maxWidth >= AppDimensions.mobileBreakpoint) {
          return tablet ?? desktop;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// Ambient mesh glow wrapper for Liquid Glass screens
class LiquidGlassBackgroundScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const LiquidGlassBackgroundScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        children: [
          // Background ambient mesh lights
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 380,
              height: 380,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.backgroundGlowBlue,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: -100,
            child: Container(
              width: 420,
              height: 420,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.backgroundGlowPurple,
              ),
            ),
          ),
          Positioned(
            top: 250,
            right: 50,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.backgroundGlowEmerald,
              ),
            ),
          ),
          // Screen Body
          SafeArea(
            bottom: bottomNavigationBar == null,
            child: body,
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
