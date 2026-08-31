import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import 'glass_card.dart';

enum MetricAccent { emerald, crimson, amber, blue, purple }

class GlassMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final MetricAccent accent;
  final String? trendText;
  final bool isPositiveTrend;
  final VoidCallback? onTap;

  const GlassMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.accent = MetricAccent.blue,
    this.trendText,
    this.isPositiveTrend = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color accentColor;
    Gradient borderGrad;

    switch (accent) {
      case MetricAccent.emerald:
        accentColor = AppColors.emeraldGreen;
        borderGrad = AppColors.emeraldGradient;
        break;
      case MetricAccent.crimson:
        accentColor = AppColors.crimsonRed;
        borderGrad = AppColors.crimsonGradient;
        break;
      case MetricAccent.amber:
        accentColor = AppColors.electricAmber;
        borderGrad = AppColors.amberGradient;
        break;
      case MetricAccent.blue:
        accentColor = AppColors.primaryBlue;
        borderGrad = AppColors.primaryGradient;
        break;
      case MetricAccent.purple:
        accentColor = AppColors.primaryPurple;
        borderGrad = const LinearGradient(colors: [Color(0xFF5E5CE6), Color(0xFFBF5AF2)]);
        break;
    }

    return GlassCard(
      glowColor: accentColor,
      accentGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accentColor.withOpacity(0.5),
          Colors.white.withOpacity(0.1),
          Colors.transparent,
        ],
      ),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
                ),
                child: Icon(icon, size: 16, color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTypography.financialMetric.copyWith(
              color: AppColors.textPrimary,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                ),
              if (trendText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isPositiveTrend ? AppColors.emeraldGreen : AppColors.crimsonRed).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositiveTrend ? Icons.trending_up : Icons.trending_down,
                        size: 12,
                        color: isPositiveTrend ? AppColors.emeraldGreen : AppColors.crimsonRed,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trendText!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isPositiveTrend ? AppColors.emeraldGreen : AppColors.crimsonRed,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
