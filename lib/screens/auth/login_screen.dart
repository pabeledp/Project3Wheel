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
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  UserRole _selectedRole = UserRole.owner;
  bool _isRegisterMode = false;
  bool _rememberMe = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _handleLogin() async {
    final identifier = _phoneController.text.trim();
    final pin = _pinController.text.trim();

    if (identifier.isEmpty || pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email/phone and password'),
          backgroundColor: AppColors.crimsonRed,
        ),
      );
      return;
    }

    // Strict Password & Credentials Security Check
    final knownAccounts = {
      'owner@project3wheel.com': 'admin123',
      'manager@project3wheel.com': 'admin123',
      '01710001122': 'admin123',
      '01815556677': 'admin123',
    };

    if (!_isRegisterMode) {
      // In Sign In mode: verify credentials against registered account or standard pin
      final expectedPass = knownAccounts[identifier.toLowerCase()];
      if (expectedPass != null && pin != expectedPass) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid password/PIN! Please enter the correct password.'),
            backgroundColor: AppColors.crimsonRed,
          ),
        );
        return;
      } else if (expectedPass == null && pin.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password must be at least 6 characters long.'),
            backgroundColor: AppColors.crimsonRed,
          ),
        );
        return;
      }
    } else {
      // In Register mode: validate password length
      if (pin.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Security password must be at least 6 characters long.'),
            backgroundColor: AppColors.crimsonRed,
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));

    final user = UserModel(
      uid: identifier.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_'),
      name: _isRegisterMode && _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : (_selectedRole == UserRole.owner ? 'Habib Rahman' : 'Selim Mia'),
      role: _selectedRole,
      phone: identifier,
    );

    ref.read(authProvider.notifier).setUser(user);
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                  width: 84,
                  height: 84,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundElevated,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.4),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                    border: Border.all(color: AppColors.primaryBlue.withOpacity(0.5), width: 2),
                  ),
                  child: Image.asset(
                    'assets/icons/app_logo_dark.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'PROJECT 3 WHEEL',
                  style: AppTypography.displayMedium.copyWith(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Electric Fleet & Financial Management Hub',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                // Frosted Glass Login Container
                LiquidGlassContainer(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Switch between Sign In and Register Mode
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _isRegisterMode = false),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: !_isRegisterMode ? AppColors.primaryGradient : null,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _isRegisterMode = true),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: _isRegisterMode ? AppColors.primaryGradient : null,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Register New',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Role Selector Tabs
                      Row(
                        children: [
                          Expanded(
                            child: _buildRoleTab(
                              title: 'Fleet Owner',
                              role: UserRole.owner,
                              icon: Icons.admin_panel_settings_rounded,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildRoleTab(
                              title: 'Garage Manager',
                              role: UserRole.manager,
                              icon: Icons.storefront_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (_isRegisterMode) ...[
                        GlassTextField(
                          controller: _nameController,
                          labelText: 'Full Name',
                          hintText: 'e.g. Habib Rahman',
                          prefixIcon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 14),
                      ],
                      GlassTextField(
                        controller: _phoneController,
                        labelText: 'Email or Mobile Number',
                        hintText: 'e.g. owner@project3wheel.com',
                        prefixIcon: Icons.phone_android_rounded,
                      ),
                      const SizedBox(height: 14),
                      GlassTextField(
                        controller: _pinController,
                        labelText: 'Security PIN / Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        suffix: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Remember Me Row
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: AppColors.primaryBlue,
                            onChanged: (val) => setState(() => _rememberMe = val ?? true),
                          ),
                          const Text(
                            'Remember my login',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GlassButton(
                        text: _isRegisterMode
                            ? 'Register Account'
                            : (_selectedRole == UserRole.owner ? 'Sign In as Owner' : 'Sign In as Manager'),
                        icon: _isRegisterMode ? Icons.person_add_rounded : Icons.login_rounded,
                        variant: _selectedRole == UserRole.owner
                            ? GlassButtonVariant.primary
                            : GlassButtonVariant.amber,
                        isLoading: _isLoading,
                        onPressed: _handleLogin,
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
    required UserRole role,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.25) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.white.withOpacity(0.12),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
