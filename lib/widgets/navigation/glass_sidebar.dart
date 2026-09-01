import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../models/user_model.dart';
import '../glass/glass_pill_badge.dart';

class GlassSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final UserModel currentUser;
  final VoidCallback onRoleSwitch;
  final VoidCallback onSignOut;
  final VoidCallback? onEditProfile;

  const GlassSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.currentUser,
    required this.onRoleSwitch,
    required this.onSignOut,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppDimensions.blurHeavy,
          sigmaY: AppDimensions.blurHeavy,
        ),
        child: Container(
          width: AppDimensions.sidebarWidth,
          decoration: BoxDecoration(
            color: AppColors.backgroundCard.withOpacity(0.75),
            border: Border(
              right: BorderSide(
                color: Colors.white.withOpacity(0.12),
                width: 1.0,
              ),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // App Branding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.electric_rickshaw,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PROJECT 3 WHEEL',
                          style: AppTypography.titleSmall.copyWith(
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Fleet Hub v1.0',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primaryBlue,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Navigation Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildNavItem(0, Icons.speed_rounded, 'Dashboard'),
                    _buildNavItem(1, Icons.receipt_long_rounded, 'Collections Ledger'),
                    _buildNavItem(2, Icons.account_balance_wallet_rounded, 'Garage Expenses'),
                    _buildNavItem(3, Icons.people_alt_rounded, 'Drivers & Dues'),
                    _buildNavItem(4, Icons.assessment_rounded, 'Financial P&L Reports'),
                    _buildNavItem(5, Icons.handshake_rounded, 'Shareholders & Equity'),
                    _buildNavItem(6, Icons.radar_rounded, 'GPS Fleet Tracking'),
                  ],
                ),
              ),
              // User Profile & Role Switcher
              InkWell(
                onTap: onEditProfile,
                borderRadius: AppDimensions.borderRadiusMedium,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.glassWhiteLight,
                    borderRadius: AppDimensions.borderRadiusMedium,
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primaryBlue.withOpacity(0.25),
                            child: Text(
                              currentUser.name.isNotEmpty ? currentUser.name[0] : 'U',
                              style: const TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        currentUser.name,
                                        style: AppTypography.labelMedium.copyWith(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryBlue),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                GlassPillBadge(
                                  text: currentUser.isOwner ? 'OWNER' : 'MANAGER',
                                  variant: currentUser.isOwner ? GlassPillVariant.blue : GlassPillVariant.amber,
                                  fontSize: 9,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: onRoleSwitch,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    currentUser.isOwner ? 'Switch to Manager' : 'Switch to Owner',
                                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.logout_rounded, size: 16, color: AppColors.crimsonRed),
                            onPressed: onSignOut,
                            tooltip: 'Sign Out',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String title) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onItemSelected(index),
          borderRadius: AppDimensions.borderRadiusMedium,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.primaryGradient : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: AppDimensions.borderRadiusMedium,
              border: isSelected
                  ? Border.all(color: Colors.white.withOpacity(0.3), width: 1)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
