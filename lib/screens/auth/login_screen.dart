import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/glass/glass_text_field.dart';
import '../../widgets/layout/responsive_layout_builder.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController(text: '01710001122');
  final _pinController = TextEditingController(text: '1234');
  UserRole _selectedRole = UserRole.owner;
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final user = UserModel(
      uid: _selectedRole == UserRole.owner ? 'OWNER-001' : 'MGR-SELIM',
      name: _selectedRole == UserRole.owner ? 'Habib Rahman' : 'Selim Mia',
      role: _selectedRole,
      phone: _phoneController.text.trim(),
    );

    ref.read(authProvider.notifier).setUser(user);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidGlassBackgroundScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing Rickshaw Brand Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.5),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                    border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                  ),
                  child: const Icon(
                    Icons.electric_rickshaw,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'PROJECT 3 WHEEL',
                  style: AppTypography.displayMedium.copyWith(fontSize: 26),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Electric Fleet & Financial Management Hub',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                // Frosted Glass Login Container
                LiquidGlassContainer(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Select Account Role',
                        style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      // Role Selector Tabs
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: AppDimensions.borderRadiusMedium,
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildRoleTab(
                                title: 'Fleet Owner',
                                subtitle: 'Full Admin Access',
                                role: UserRole.owner,
                                icon: Icons.admin_panel_settings_rounded,
                              ),
                            ),
                            Expanded(
                              child: _buildRoleTab(
                                title: 'Garage Manager',
                                subtitle: 'Daily Entry Mode',
                                role: UserRole.manager,
                                icon: Icons.storefront_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      GlassTextField(
                        controller: _phoneController,
                        labelText: 'Registered Mobile Number',
                        hintText: 'e.g. 01710001122',
                        prefixIcon: Icons.phone_android_rounded,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      GlassTextField(
                        controller: _pinController,
                        labelText: 'Security PIN / Password',
                        hintText: '••••',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 28),
                      GlassButton(
                        text: _selectedRole == UserRole.owner
                            ? 'Sign In as Owner'
                            : 'Sign In as Manager',
                        icon: Icons.login_rounded,
                        variant: _selectedRole == UserRole.owner
                            ? GlassButtonVariant.primary
                            : GlassButtonVariant.amber,
                        isLoading: _isLoading,
                        onPressed: _handleLogin,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Offline First • Auto-syncing with Cloud Firestore',
                          style: AppTypography.bodySmall.copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTab({
    required String title,
    required String subtitle,
    required UserRole role,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
          if (role == UserRole.owner) {
            _phoneController.text = '01710001122';
          } else {
            _phoneController.text = '01815556677';
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (role == UserRole.owner ? AppColors.primaryBlue.withOpacity(0.3) : AppColors.electricAmber.withOpacity(0.3))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: role == UserRole.owner ? AppColors.primaryBlue : AppColors.electricAmber,
                  width: 1.2,
                )
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? (role == UserRole.owner ? AppColors.primaryBlue : AppColors.electricAmber)
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
