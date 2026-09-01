import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/fleet_provider.dart';
import '../../providers/collection_provider.dart';
import '../../providers/report_provider.dart';
import '../../providers/sync_provider.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_metric_card.dart';
import '../../widgets/glass/glass_pill_badge.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/glass/glass_text_field.dart';
import '../scanner/qr_scanner_screen.dart';
import '../collection/daily_collection_form_screen.dart';
import '../expense/add_expense_screen.dart';
import '../driver/driver_ledger_screen.dart';
import 'manage_rickshaws_dialog.dart';

class MobileManagerHomeScreen extends ConsumerWidget {
  const MobileManagerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(financialSummaryProvider);
    final fleetState = ref.watch(fleetProvider);
    final collectionState = ref.watch(collectionProvider);
    final syncState = ref.watch(syncProvider);
    final currentUser = ref.watch(authProvider).currentUser;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // Top Sliver App Bar with Liquid Glass Styling (Pinned Sticky)
          SliverAppBar(
            backgroundColor: AppColors.backgroundDark,
            elevation: 0,
            floating: false,
            pinned: true,
            title: GestureDetector(
              onTap: () {
                _showMobileEditProfileDialog(context, ref, currentUser);
              },
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primaryBlue.withOpacity(0.35),
                        child: Text(
                          currentUser.name.isNotEmpty ? currentUser.name[0].toUpperCase() : 'U',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryBlue,
                        ),
                        child: const Icon(Icons.edit, size: 8, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            currentUser.name.isNotEmpty ? currentUser.name : 'Fleet User',
                            style: AppTypography.titleSmall,
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.edit_outlined, size: 12, color: AppColors.primaryBlue),
                        ],
                      ),
                      Text(
                        currentUser.garageName.isNotEmpty ? currentUser.garageName : currentUser.roleDisplayName,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.electricAmber, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              // Online / Offline Sync Orb
              GestureDetector(
                onTap: () => ref.read(syncProvider.notifier).toggleSimulatedOffline(),
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (syncState.isOnline ? AppColors.emeraldGreen : AppColors.electricAmber).withOpacity(0.18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (syncState.isOnline ? AppColors.emeraldGreen : AppColors.electricAmber).withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: syncState.isOnline ? AppColors.emeraldGreen : AppColors.electricAmber,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        syncState.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: syncState.isOnline ? AppColors.emeraldGreen : AppColors.electricAmber,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Body Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Quick Action Grid (Manager primary workflows)
                  Text('Quick Fleet Operations', style: AppTypography.labelMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          context: context,
                          title: 'Scan QR Code',
                          subtitle: 'Instant Rickshaw Lookup',
                          icon: Icons.qr_code_scanner_rounded,
                          gradient: AppColors.primaryGradient,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const QrScannerScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionCard(
                          context: context,
                          title: 'Record Deposit',
                          subtitle: 'Daily Collections Form',
                          icon: Icons.add_card_rounded,
                          gradient: AppColors.emeraldGradient,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const DailyCollectionFormScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          context: context,
                          title: 'Add Expense',
                          subtitle: 'Mechanic / Parts / Rent',
                          icon: Icons.receipt_long_rounded,
                          gradient: AppColors.crimsonGradient,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionCard(
                          context: context,
                          title: 'Driver Ledger',
                          subtitle: 'Due Reminders via SMS',
                          icon: Icons.people_alt_rounded,
                          gradient: AppColors.amberGradient,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const DriverLedgerScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Today's Performance Summary
                  Text("Today's Garage Financials", style: AppTypography.labelMedium),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                    children: [
                      GlassMetricCard(
                        title: "Today's Collections",
                        value: CurrencyFormatter.formatBDT(summary.todayRevenue),
                        subtitle: '${collectionState.todayCollections.length} Deposits logged',
                        icon: Icons.savings_rounded,
                        accent: MetricAccent.emerald,
                        trendText: '${summary.collectionRate.toStringAsFixed(0)}% Rate',
                        isPositiveTrend: true,
                      ),
                      GlassMetricCard(
                        title: 'Daily Expenses',
                        value: CurrencyFormatter.formatBDT(summary.todayExpense),
                        subtitle: 'Repair & running costs',
                        icon: Icons.build_rounded,
                        accent: MetricAccent.crimson,
                        trendText: 'Today',
                        isPositiveTrend: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Active Fleet Overview Card
                  LiquidGlassContainer(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Fleet Status Overview', style: AppTypography.titleSmall),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (c) => const ManageRickshawsDialog(),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.4)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.electric_rickshaw, size: 14, color: AppColors.primaryBlue),
                                    SizedBox(width: 4),
                                    Text('Manage Fleet', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFleetStatColumn('Total Fleet', '${fleetState.totalRickshaws}', AppColors.primaryBlue),
                            _buildFleetStatColumn('Active on Road', '${fleetState.activeRickshaws}', AppColors.emeraldGreenLight),
                            _buildFleetStatColumn('In Repair', '${fleetState.maintenanceRickshaws}', AppColors.electricAmberLight),
                            _buildFleetStatColumn('Defaulters', '${fleetState.defaultersCount}', AppColors.crimsonRedLight),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120), // Bottom padding for floating navigation bar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlassContainer(
        padding: const EdgeInsets.all(16),
        borderGradient: gradient,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTypography.titleSmall.copyWith(fontSize: 14)),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showMobileEditProfileDialog(BuildContext context, WidgetRef ref, UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final garageController = TextEditingController(text: user.garageName.isNotEmpty ? user.garageName : 'My Electric Garage');
    final phoneController = TextEditingController(text: user.phone);

    showDialog(
      context: context,
      builder: (dialogCtx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: LiquidGlassContainer(
            padding: const EdgeInsets.all(22),
            child: SingleChildScrollView(
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
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.manage_accounts_rounded, color: AppColors.primaryBlue, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Text('Edit Profile & Garage', style: AppTypography.titleMedium),
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
                    hintText: 'Enter full name',
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
                    hintText: '017xxxxxxxx',
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

                      // Sync update to Cloud Firestore
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
                        debugPrint('Firestore profile update note: $e');
                      }

                      if (context.mounted) Navigator.pop(dialogCtx);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile and Garage Name updated across app!'),
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
    );
  }

  Widget _buildFleetStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: AppTypography.financialAmount.copyWith(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, fontSize: 10)),
      ],
    );
  }
}
