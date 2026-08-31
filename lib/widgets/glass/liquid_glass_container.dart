import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// The core Liquid Glass building block.
/// Features dynamic BackdropFilter blur, specular gradient rim, and translucent layers.
class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blurSigmaX;
  final double blurSigmaY;
  final Color? color;
  final Gradient? gradient;
  final Gradient? borderGradient;
  final double borderWidth;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blurSigmaX = AppDimensions.blurStandard,
    this.blurSigmaY = AppDimensions.blurStandard,
    this.color,
    this.gradient,
    this.borderGradient,
    this.borderWidth = 1.0,
    this.shadows,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppDimensions.borderRadiusLarge;

    Widget content = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColors.glassWhiteLight) : null,
        gradient: gradient,
        borderRadius: effectiveRadius,
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          splashColor: AppColors.primaryBlue.withOpacity(0.12),
          highlightColor: Colors.white.withOpacity(0.04),
          child: content,
        ),
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        boxShadow: shadows ?? [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 28,
            offset: const Offset(0, 10),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.02),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigmaX, sigmaY: blurSigmaY),
          child: CustomPaint(
            foregroundPainter: _SpecularBorderPainter(
              borderRadius: effectiveRadius,
              borderWidth: borderWidth,
              gradient: borderGradient ?? AppColors.specularBorderGradient,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _SpecularBorderPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final double borderWidth;
  final Gradient gradient;

  _SpecularBorderPainter({
    required this.borderRadius,
    required this.borderWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect).deflate(borderWidth / 2);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = gradient.createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _SpecularBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.gradient != gradient;
  }
}
