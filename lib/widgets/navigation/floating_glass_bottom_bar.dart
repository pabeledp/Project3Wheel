import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class FloatingGlassBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onScanPressed;

  const FloatingGlassBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onScanPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Glass Bar
          ClipRRect(
            borderRadius: AppDimensions.borderRadiusExtraLarge,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: AppDimensions.blurHeavy,
                sigmaY: AppDimensions.blurHeavy,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.glassDarkMedium,
                  borderRadius: AppDimensions.borderRadiusExtraLarge,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.18),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.grid_view_rounded, 'Dashboard'),
                    _buildNavItem(1, Icons.account_balance_wallet_rounded, 'Expense'),
                    const SizedBox(width: 56), // Spacer for center floating QR button
                    _buildNavItem(2, Icons.people_alt_rounded, 'Drivers'),
                    _buildNavItem(3, Icons.radar_rounded, 'GPS Live'),
                  ],
                ),
              ),
            ),
          ),
          // Center Floating Glass QR Scanner Trigger
          Positioned(
            top: -18,
            child: GestureDetector(
              onTap: onScanPressed,
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.35),
                    width: 2.0,
                  ),
                ),
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.primaryBlue : AppColors.textSecondary;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: color,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 2),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
