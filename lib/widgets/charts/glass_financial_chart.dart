import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../glass/glass_card.dart';

class GlassFinancialChart extends StatelessWidget {
  final double weeklyRevenue;
  final double weeklyExpense;

  const GlassFinancialChart({
    super.key,
    required this.weeklyRevenue,
    required this.weeklyExpense,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    // Relative mock heights for the 7-day spark bars
    final revenueFactors = [0.65, 0.8, 0.75, 0.9, 0.85, 1.0, 0.7];
    final expenseFactors = [0.3, 0.25, 0.4, 0.35, 0.5, 0.2, 0.15];

    return GlassCard(
      glowColor: AppColors.primaryBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '7-Day Fleet Revenue Velocity',
                    style: AppTypography.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Daily collections vs operational expenditures',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  _buildLegend(AppColors.emeraldGreen, 'Collections'),
                  const SizedBox(width: 14),
                  _buildLegend(AppColors.crimsonRed, 'Expenses'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final revHeight = 120.0 * revenueFactors[index];
                final expHeight = 120.0 * expenseFactors[index];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Collections Bar
                        Container(
                          width: 14,
                          height: revHeight,
                          decoration: BoxDecoration(
                            gradient: AppColors.emeraldGradient,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.emeraldGreen.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Expenses Bar
                        Container(
                          width: 14,
                          height: expHeight,
                          decoration: BoxDecoration(
                            gradient: AppColors.crimsonGradient,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.crimsonRed.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      days[index],
                      style: AppTypography.labelSmall.copyWith(
                        color: index == 5 ? AppColors.primaryBlue : AppColors.textTertiary,
                        fontWeight: index == 5 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.8),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
