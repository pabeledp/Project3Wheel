import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import 'liquid_glass_container.dart';

/// High-gloss card with ambient glow and specular edge reflections.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? glowColor;
  final Gradient? accentGradient;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.glowColor,
    this.accentGradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppDimensions.borderRadiusLarge;

    return Stack(
      children: [
        if (glowColor != null)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: glowColor!.withOpacity(0.18),
                boxShadow: [
                  BoxShadow(
                    color: glowColor!.withOpacity(0.25),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        LiquidGlassContainer(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(AppDimensions.space20),
          margin: margin,
          borderRadius: effectiveRadius,
          color: AppColors.glassWhiteLight,
          borderGradient: accentGradient ?? AppColors.specularBorderGradient,
          onTap: onTap,
          child: child,
        ),
      ],
    );
  }
}
