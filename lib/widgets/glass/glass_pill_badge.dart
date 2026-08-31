import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../models/collection_model.dart';
import '../../models/rickshaw_model.dart';
import 'liquid_glass_container.dart';

enum GlassPillVariant { emerald, crimson, amber, blue, neutral }

class GlassPillBadge extends StatelessWidget {
  final String text;
  final IconData? icon;
  final GlassPillVariant variant;
  final double fontSize;
  final bool showDot;

  const GlassPillBadge({
    super.key,
    required this.text,
    this.icon,
    this.variant = GlassPillVariant.blue,
    this.fontSize = 11,
    this.showDot = false,
  });

  factory GlassPillBadge.fromPaymentStatus(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return const GlassPillBadge(
          text: 'PAID',
          variant: GlassPillVariant.emerald,
          showDot: true,
        );
      case PaymentStatus.due:
        return const GlassPillBadge(
          text: 'PARTIAL DUE',
          variant: GlassPillVariant.amber,
          showDot: true,
        );
      case PaymentStatus.unpaid:
        return const GlassPillBadge(
          text: 'UNPAID',
          variant: GlassPillVariant.crimson,
          showDot: true,
        );
    }
  }

  factory GlassPillBadge.fromRickshawStatus(RickshawStatus status) {
    switch (status) {
      case RickshawStatus.active:
        return const GlassPillBadge(
          text: 'ACTIVE',
          variant: GlassPillVariant.emerald,
          showDot: true,
        );
      case RickshawStatus.maintenance:
        return const GlassPillBadge(
          text: 'MAINTENANCE',
          variant: GlassPillVariant.amber,
          showDot: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color baseColor;
    switch (variant) {
      case GlassPillVariant.emerald:
        baseColor = AppColors.emeraldGreen;
        break;
      case GlassPillVariant.crimson:
        baseColor = AppColors.crimsonRed;
        break;
      case GlassPillVariant.amber:
        baseColor = AppColors.electricAmber;
        break;
      case GlassPillVariant.blue:
        baseColor = AppColors.primaryBlue;
        break;
      case GlassPillVariant.neutral:
        baseColor = AppColors.textSecondary;
        break;
    }

    return LiquidGlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      borderRadius: AppDimensions.borderRadiusPill,
      color: baseColor.withOpacity(0.15),
      borderWidth: 1.0,
      borderGradient: LinearGradient(
        colors: [
          baseColor.withOpacity(0.6),
          baseColor.withOpacity(0.15),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: baseColor,
                boxShadow: [
                  BoxShadow(
                    color: baseColor.withOpacity(0.8),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            Icon(icon, size: fontSize + 1, color: baseColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: AppTypography.labelSmall.copyWith(
              color: baseColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
