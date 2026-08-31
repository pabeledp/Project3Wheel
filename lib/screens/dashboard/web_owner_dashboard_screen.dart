import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/driver_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/fleet_provider.dart';
import '../../providers/collection_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/report_provider.dart';
import '../../providers/sync_provider.dart';
import '../../services/sms/sms_gateway_service.dart';
import '../../services/export/pdf_report_service.dart';
import '../../services/export/excel_report_service.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_metric_card.dart';
import '../../widgets/glass/glass_pill_badge.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/charts/glass_financial_chart.dart';

class WebOwnerDashboardScreen extends ConsumerStatefulWidget {
  const WebOwnerDashboardScreen({super.key});

  @override
  ConsumerState<WebOwnerDashboardScreen> createState() => _WebOwnerDashboardScreenState();
}

class _WebOwnerDashboardScreenState extends ConsumerState<WebOwnerDashboardScreen> {
  void _sendQuickSms(DriverModel driver) async {
    final smsService = SmsGatewayService();
    final log = await smsService.sendDueReminder(
      driverId: driver.driverId,
      driverName: driver.name,
      driverPhone: driver.phone,
      dueAmount: driver.totalDue,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: log.isSuccess ? AppColors.emeraldGreen : AppColors.crimsonRed,
        content: Text(log.isSuccess ? 'Bengali SMS sent to ${driver.name}' : 'SMS failed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(financialSummaryProvider);
    final fleetState = ref.watch(fleetProvider);
    final collectionState = ref.watch(collectionProvider);
    final syncState = ref.watch(syncProvider);
    final currentUser = ref.watch(authProvider).currentUser;

    final defaulters = fleetState.drivers.where((d) => d.hasDue).toList()
      ..sort((a, b) => b.totalDue.compareTo(a.totalDue));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: Greeting, Sync Orb, Fast Export Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Owner Executive Dashboard',
                          style: AppTypography.displayMedium.copyWith(fontSize: 26),
                        ),
                        const SizedBox(width: 14),
                        // Online / Sync Status Orb
                        GestureDetector(
                          onTap: () => ref.read(syncProvider.notifier).toggleSimulatedOffline(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (syncState.isOnline ? AppColors.emeraldGreen : AppColors.electricAmber).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: (syncState.isOnline ? AppColors.emeraldGreen : AppColors.electricAmber).withOpacity(0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: syncState.isOnline ? AppColors.emeraldGreen : AppColors.electricAmber,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (syncState.isOnline ? AppColors.emeraldGreen : AppColors.electricAmber).withOpacity(0.8),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  syncState.isOnline
                                      ? (syncState.hasPendingSync ? 'Syncing (${syncState.pendingCount})' : 'Live Firestore')
                                      : 'Offline Queue (${syncState.pendingCount})',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: syncState.isOnline ? AppColors.emeraldGreen : AppColors.electricAmber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome back, ${currentUser.name} • Full Administrative Oversight & Real-time P&L',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
                // Fast Export Buttons
                Row(
                  children: [
                    GlassButton(
                      text: 'P&L Statement (PDF)',
                      icon: Icons.picture_as_pdf_rounded,
                      variant: GlassButtonVariant.primary,
                      height: 42,
                      fontSize: 13,
                      onPressed: () async {
                        final bytes = await PdfReportService.generateMonthlyPnlPdf(
                          month: DateTime.now(),
                          collections: collectionState.collections,
                          expenses: ref.read(expenseProvider).expenses,
                          garageName: 'Project 3 Wheel - Central Fleet Hub',
                        );
                        await PdfReportService.printReport(bytes, documentName: 'Executive_PNL');
                      },
                    ),
                    const SizedBox(width: 12),
                    GlassButton(
                      text: 'Excel Audit',
                      icon: Icons.table_chart_rounded,
                      variant: GlassButtonVariant.emerald,
                      height: 42,
                      fontSize: 13,
                      onPressed: () {
                        final bytes = ExcelReportService.generateFullAuditExcel(
                          collections: collectionState.collections,
                          expenses: ref.read(expenseProvider).expenses,
                          drivers: fleetState.drivers,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.emeraldGreen,
                            content: Text('Full fleet audit workbook compiled (${bytes.lengthInBytes} bytes)!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            // High-Gloss P&L Metric Cards
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: [
                GlassMetricCard(
                  title: "Today's Revenue",
                  value: CurrencyFormatter.formatBDT(summary.todayRevenue),
                  subtitle: '${collectionState.todayCollections.length} Deposits logged today',
                  icon: Icons.account_balance_wallet_rounded,
                  accent: MetricAccent.emerald,
                  trendText: '${summary.collectionRate.toStringAsFixed(0)}% Collected',
                  isPositiveTrend: true,
                ),
                GlassMetricCard(
                  title: 'Daily Expenses',
                  value: CurrencyFormatter.formatBDT(summary.todayExpense),
                  subtitle: 'Parts, mechanic, charging fees',
                  icon: Icons.receipt_long_rounded,
                  accent: MetricAccent.crimson,
                  trendText: 'Today',
                  isPositiveTrend: false,
                ),
                GlassMetricCard(
                  title: 'Net Cash Flow (Today)',
                  value: CurrencyFormatter.formatBDT(summary.todayNetCashFlow),
                  subtitle: 'Revenue minus daily costs',
                  icon: Icons.trending_up_rounded,
                  accent: summary.todayNetCashFlow >= 0 ? MetricAccent.blue : MetricAccent.crimson,
                  trendText: summary.todayNetCashFlow >= 0 ? 'Surplus' : 'Deficit',
                  isPositiveTrend: summary.todayNetCashFlow >= 0,
                ),
                GlassMetricCard(
                  title: 'Cumulative Overdue Dues',
                  value: CurrencyFormatter.formatBDT(summary.totalOutstandingDue),
                  subtitle: '${fleetState.defaultersCount} drivers with pending dues',
                  icon: Icons.warning_amber_rounded,
                  accent: MetricAccent.amber,
                  trendText: 'Requires Attention',
                  isPositiveTrend: false,
                ),
              ],
            ),
            const SizedBox(height: 28),
            // Middle Row: 7-Day Velocity Chart & Fleet Availability Stats
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: GlassFinancialChart(
                    weeklyRevenue: summary.todayRevenue * 7,
                    weeklyExpense: summary.todayExpense * 7,
                  ),
                ),
                const SizedBox(width: 16),
                // Fleet Readiness Card
                Expanded(
                  flex: 2,
                  child: LiquidGlassContainer(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fleet Status & Fleet Health', style: AppTypography.titleSmall),
                        const SizedBox(height: 4),
                        Text('Electric rickshaws active vs maintenance', style: AppTypography.bodySmall),
                        const SizedBox(height: 16),
                        _buildFleetHealthRow('Total Registered Fleet', '${fleetState.totalRickshaws} Vehicles', AppColors.primaryBlue),
                        const Divider(color: Colors.white12, height: 16),
                        _buildFleetHealthRow('Active on Road', '${fleetState.activeRickshaws} Active', AppColors.emeraldGreenLight),
                        const Divider(color: Colors.white12, height: 16),
                        _buildFleetHealthRow('In Garage Maintenance', '${fleetState.maintenanceRickshaws} In Repair', AppColors.electricAmberLight),
                        const Divider(color: Colors.white12, height: 16),
                        _buildFleetHealthRow('Registered Drivers', '${fleetState.totalDrivers} Drivers', AppColors.textPrimary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            // Defaulters Data Table with Glass Pill Tags & 1-Tap SMS Reminders
            LiquidGlassContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Top Defaulters & Due Management Table', style: AppTypography.titleSmall),
                          const SizedBox(height: 4),
                          Text('Direct Bengali SMS dispatch and collection triggers', style: AppTypography.bodySmall),
                        ],
                      ),
                      GlassPillBadge(
                        text: '${defaulters.length} DEFAULTERS',
                        variant: GlassPillVariant.crimson,
                        showDot: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: const Row(
                      children: [
                        Expanded(flex: 2, child: Text('Driver Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                        Expanded(flex: 2, child: Text('Phone & Contact', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                        Expanded(flex: 1, child: Text('Rickshaw', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                        Expanded(flex: 2, child: Text('Outstanding Due', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                        Expanded(flex: 1, child: Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
                        Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text('Action', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Table Rows
                  ...defaulters.take(6).map((driver) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.glassWhiteLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppColors.crimsonRed.withOpacity(0.25),
                                  child: Text(driver.name[0], style: const TextStyle(fontSize: 11, color: AppColors.crimsonRedLight, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(driver.name, style: AppTypography.titleSmall.copyWith(fontSize: 13), overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                          Expanded(flex: 2, child: Text(driver.phone, style: AppTypography.bodySmall)),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(driver.activeRickshawId ?? 'N/A', style: const TextStyle(fontSize: 11, color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              CurrencyFormatter.formatBDT(driver.totalDue),
                              style: AppTypography.financialAmount.copyWith(color: AppColors.crimsonRedLight, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: GlassPillBadge(text: 'DUE', variant: GlassPillVariant.amber, fontSize: 9),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GlassButton(
                                text: 'Send SMS',
                                icon: Icons.sms_outlined,
                                variant: GlassButtonVariant.amber,
                                height: 32,
                                fontSize: 11,
                                onPressed: () => _sendQuickSms(driver),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFleetHealthRow(String title, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTypography.titleSmall.copyWith(color: color, fontSize: 13)),
      ],
    );
  }
}
