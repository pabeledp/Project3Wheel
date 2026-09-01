import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/layout/responsive_layout_builder.dart';
import '../../widgets/navigation/glass_sidebar.dart';
import '../../widgets/navigation/floating_glass_bottom_bar.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/glass/glass_text_field.dart';
import '../../core/constants/app_colors.dart';
import 'auth/login_screen.dart';
import 'dashboard/web_owner_dashboard_screen.dart';
import 'dashboard/mobile_manager_home_screen.dart';
import 'scanner/qr_scanner_screen.dart';
import 'collection/collection_ledger_screen.dart';
import 'expense/expense_list_screen.dart';
import 'driver/driver_ledger_screen.dart';
import 'reports/financial_reports_screen.dart';
import 'gps/gps_tracking_placeholder_screen.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _selectedWebIndex = 0;
  int _selectedMobileIndex = 0;

  void _showEditProfileDialog(BuildContext context, UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone);

    showDialog(
      context: context,
      builder: (dialogCtx) => Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: LiquidGlassContainer(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit Profile Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: () => Navigator.pop(dialogCtx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    GlassTextField(
                      controller: nameController,
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 14),
                    GlassTextField(
                      controller: phoneController,
                      labelText: 'Mobile Number',
                      hintText: 'Enter your phone number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 22),
                    GlassButton(
                      text: 'Save Changes',
                      icon: Icons.save_rounded,
                      variant: GlassButtonVariant.primary,
                      onPressed: () {
                        final updated = user.copyWith(
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                        );
                        ref.read(authProvider.notifier).setUser(updated);
                        Navigator.pop(dialogCtx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile updated successfully!'),
                            backgroundColor: AppColors.emeraldGreen,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (!authState.isAuthenticated) {
      return const LoginScreen();
    }

    final currentUser = authState.currentUser;

    return ResponsiveLayoutBuilder(
      // Desktop / Web Layout with Glass Sidebar
      desktop: LiquidGlassBackgroundScaffold(
        body: Row(
          children: [
            GlassSidebar(
              selectedIndex: _selectedWebIndex,
              currentUser: currentUser,
              onItemSelected: (index) => setState(() => _selectedWebIndex = index),
              onRoleSwitch: () {
                final newRole = currentUser.isOwner ? UserRole.manager : UserRole.owner;
                ref.read(authProvider.notifier).switchRole(newRole);
              },
              onSignOut: () {
                ref.read(authProvider.notifier).signOut();
              },
              onEditProfile: () => _showEditProfileDialog(context, currentUser),
            ),
            Expanded(
              child: _buildDesktopScreen(_selectedWebIndex),
            ),
          ],
        ),
      ),
      // Mobile Layout with Floating Glass Bottom Bar
      mobile: LiquidGlassBackgroundScaffold(
        body: _buildMobileScreen(_selectedMobileIndex),
        bottomNavigationBar: FloatingGlassBottomBar(
          currentIndex: _selectedMobileIndex,
          onTap: (index) => setState(() => _selectedMobileIndex = index),
          onScanPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QrScannerScreen()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopScreen(int index) {
    switch (index) {
      case 0:
        return const WebOwnerDashboardScreen();
      case 1:
        return const CollectionLedgerScreen();
      case 2:
        return const ExpenseListScreen();
      case 3:
        return const DriverLedgerScreen();
      case 4:
        return const FinancialReportsScreen();
      case 5:
        return const FinancialReportsScreen(); // Shareholders & PnL
      case 6:
        return const GpsTrackingPlaceholderScreen();
      default:
        return const WebOwnerDashboardScreen();
    }
  }

  Widget _buildMobileScreen(int index) {
    switch (index) {
      case 0:
        return const MobileManagerHomeScreen();
      case 1:
        return const ExpenseListScreen();
      case 2:
        return const DriverLedgerScreen();
      case 3:
        return const GpsTrackingPlaceholderScreen();
      default:
        return const MobileManagerHomeScreen();
    }
  }
}
