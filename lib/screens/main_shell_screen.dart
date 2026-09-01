import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/layout/responsive_layout_builder.dart';
import '../../widgets/navigation/glass_sidebar.dart';
import '../../widgets/navigation/floating_glass_bottom_bar.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/glass/glass_text_field.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import 'auth/login_screen.dart';
import 'dashboard/web_owner_dashboard_screen.dart';
import 'dashboard/mobile_manager_home_screen.dart';
import 'scanner/qr_scanner_screen.dart';
import 'collection/collection_ledger_screen.dart';
import 'expense/expense_list_screen.dart';
import 'driver/driver_ledger_screen.dart';
import 'reports/financial_reports_screen.dart';
import 'gps/gps_tracking_placeholder_screen.dart';
import 'rickshaw/rickshaw_list_screen.dart';
import 'shareholder/shareholder_list_screen.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _selectedWebIndex = 0;
  int _selectedMobileIndex = 0;

  void _showMoreMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LiquidGlassContainer(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('More Hub Features & Tools', style: AppTypography.titleMedium),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.manage_accounts_rounded, color: AppColors.primaryBlue),
              ),
              title: const Text('User Profile & Garage Settings', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: const Text('Edit name, garage/fleet title & mobile number', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white54),
              onTap: () {
                Navigator.pop(ctx);
                final user = ref.read(authProvider).currentUser;
                _showEditProfileDialog(context, user);
              },
            ),
            const Divider(color: Colors.white12, height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.crimsonRed.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.crimsonRedLight),
              ),
              title: const Text('Garage Expenses', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: const Text('Record repair, power & labor costs', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpenseListScreen()));
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.handshake_rounded, color: AppColors.primaryPurple),
              ),
              title: const Text('Shareholders & Equity', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: const Text('Partner investments and dividend share', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ShareholderListScreen()));
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.emeraldGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.assessment_rounded, color: AppColors.emeraldGreenLight),
              ),
              title: const Text('Financial P&L Reports', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: const Text('Audit ledgers, Excel & PDF export', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FinancialReportsScreen()));
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.radar_rounded, color: AppColors.primaryBlue),
              ),
              title: const Text('GPS Fleet Tracking', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: const Text('Live vehicle telematics & firmware', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GpsTrackingPlaceholderScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final garageController = TextEditingController(text: user.garageName.isNotEmpty ? user.garageName : 'My Electric Garage');
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.manage_accounts_rounded, color: AppColors.primaryBlue, size: 20),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Edit Profile & Garage',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
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
                      controller: garageController,
                      labelText: 'Garage / Fleet Name',
                      hintText: 'e.g. Dhaka Express Fleet Hub',
                      prefixIcon: Icons.warehouse_outlined,
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
                      onPressed: () async {
                        final newName = nameController.text.trim();
                        final newGarage = garageController.text.trim();
                        final newPhone = phoneController.text.trim();

                        if (newName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter your name'), backgroundColor: AppColors.crimsonRed),
                          );
                          return;
                        }

                        final updated = user.copyWith(
                          name: newName,
                          garageName: newGarage.isNotEmpty ? newGarage : 'My Electric Garage',
                          phone: newPhone,
                        );

                        ref.read(authProvider.notifier).setUser(updated);

                        // Sync to Cloud Firestore
                        try {
                          final email = user.phone.contains('@') ? user.phone : '${user.uid}@project3wheel.com';
                          final docKey = email.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
                          await FirebaseFirestore.instance.collection('fleet_accounts').doc(docKey).set({
                            'userProfile': {
                              'name': newName,
                              'garageName': newGarage,
                              'phone': newPhone,
                              'email': email,
                              'role': user.isOwner ? 'owner' : 'manager',
                            },
                            'updatedAt': DateTime.now().toIso8601String(),
                          }, SetOptions(merge: true));
                        } catch (e) {
                          debugPrint('Firestore profile update: $e');
                        }

                        if (context.mounted) Navigator.pop(dialogCtx);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile and Garage Name updated!'),
                              backgroundColor: AppColors.emeraldGreen,
                            ),
                          );
                        }
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
          onTap: (index) {
            if (index == 3) {
              _showMoreMobileMenu(context);
            } else {
              setState(() => _selectedMobileIndex = index);
            }
          },
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
        return const ShareholderListScreen();
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
        return const RickshawListScreen();
      case 2:
        return const DriverLedgerScreen();
      case 3:
        return const MobileManagerHomeScreen();
      default:
        return const MobileManagerHomeScreen();
    }
  }
}
