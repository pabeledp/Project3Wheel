import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import 'liquid_glass_container.dart';

enum GlassButtonVariant { primary, emerald, crimson, amber, secondary }

class GlassButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final GlassButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double height;
  final double fontSize;

  const GlassButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.variant = GlassButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height = AppDimensions.buttonHeight,
    this.fontSize = 15,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Gradient? fillGradient;
    Color? fallbackColor;
    Color textColor = AppColors.textPrimary;
    List<BoxShadow>? shadows;

    switch (widget.variant) {
      case GlassButtonVariant.primary:
        fillGradient = AppColors.primaryGradient;
        shadows = [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ];
        break;
      case GlassButtonVariant.emerald:
        fillGradient = AppColors.emeraldGradient;
        shadows = [
          BoxShadow(
            color: AppColors.emeraldGreen.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ];
        break;
      case GlassButtonVariant.crimson:
        fillGradient = AppColors.crimsonGradient;
        shadows = [
          BoxShadow(
            color: AppColors.crimsonRed.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ];
        break;
      case GlassButtonVariant.amber:
        fillGradient = AppColors.amberGradient;
        shadows = [
          BoxShadow(
            color: AppColors.electricAmber.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ];
        break;
      case GlassButtonVariant.secondary:
        fallbackColor = AppColors.glassWhiteMedium;
        shadows = [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
        break;
    }

    final bool isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => _controller.forward(),
      onTapUp: isDisabled ? null : (_) => _controller.reverse(),
      onTapCancel: isDisabled ? null : () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Opacity(
          opacity: isDisabled ? 0.45 : 1.0,
          child: LiquidGlassContainer(
            width: widget.width,
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            borderRadius: AppDimensions.borderRadiusLarge,
            gradient: fillGradient,
            color: fallbackColor,
            shadows: shadows,
            onTap: isDisabled ? null : widget.onPressed,
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 18, color: textColor),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text,
                          style: AppTypography.labelLarge.copyWith(
                            color: textColor,
                            fontSize: widget.fontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
