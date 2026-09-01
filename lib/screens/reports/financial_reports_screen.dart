import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_utils.dart';
import '../../models/expense_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/collection_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/fleet_provider.dart';
import '../../providers/report_provider.dart';
import '../../services/export/pdf_report_service.dart';
import '../../services/export/excel_report_service.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_metric_card.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/charts/glass_financial_chart.dart';
import '../../widgets/layout/responsive_layout_builder.dart';

class FinancialReportsScreen extends ConsumerStatefulWidget {
  const FinancialReportsScreen({super.key});

  @override
  ConsumerState<FinancialReportsScreen> createState() => _FinancialReportsScreenState();
}

class _FinancialReportsScreenState extends ConsumerState<FinancialReportsScreen> {
  final DateTime _selectedMonth = DateTime.now();
  bool _isGeneratingPdf = false;
  bool _isGeneratingExcel = false;

  void _exportPdf() async {
    setState(() => _isGeneratingPdf = true);
    final collections = ref.read(collectionProvider).collections;
    final expenses = ref.read(expenseProvider).expenses;

    final user = ref.read(authProvider).currentUser;
    final bytes = await PdfReportService.generateMonthlyPnlPdf(
      month: _selectedMonth,
      collections: collections,
      expenses: expenses,
      garageName: user.garageName.isNotEmpty ? user.garageName : 'Project 3 Wheel Fleet Hub',
    );

    if (!mounted) return;
    setState(() => _isGeneratingPdf = false);

    await PdfReportService.printReport(bytes, documentName: 'Monthly_PNL_Report');
  }

  void _exportExcel() async {
    setState(() => _isGeneratingExcel = true);
    final collections = ref.read(collectionProvider).collections;
    final expenses = ref.read(expenseProvider).expenses;
    final drivers = ref.read(fleetProvider).drivers;

    final bytes = ExcelReportService.generateFullAuditExcel(
      collections: collections,
      expenses: expenses,
      drivers: drivers,
    );

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isGeneratingExcel = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.emeraldGreen,
        content: Text('Excel Audit Workbook generated (${bytes.lengthInBytes} bytes) ready for download!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(financialSummaryProvider);
    final expenseState = ref.watch(expenseProvider);
    final categoryBreakdown = expenseState.categoryBreakdown;

    return LiquidGlassBackgroundScaffold(
      appBar: AppBar(
        title: Text('Financial P&L Analytics', style: AppTypography.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Selector & Export Triggers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Accounting Period', style: AppTypography.labelSmall),
                    const SizedBox(height: 2),
                    Text(
                      AppDateUtils.formatMonthYear(_selectedMonth),
                      style: AppTypography.titleMedium.copyWith(color: AppColors.primaryBlue),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GlassButton(
                      text: 'PDF Report',
                      icon: Icons.picture_as_pdf_rounded,
                      variant: GlassButtonVariant.primary,
                      height: 38,
                      fontSize: 12,
                      isLoading: _isGeneratingPdf,
                      onPressed: _exportPdf,
                    ),
                    const SizedBox(width: 8),
                    GlassButton(
                      text: 'Excel Audit',
                      icon: Icons.table_chart_rounded,
                      variant: GlassButtonVariant.emerald,
                      height: 38,
                      fontSize: 12,
                      isLoading: _isGeneratingExcel,
                      onPressed: _exportExcel,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Metric Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isWide ? 1.35 : 1.15,
                  children: [
                    GlassMetricCard(
                      title: 'Total Revenue',
                      value: CurrencyFormatter.formatBDT(summary.totalRevenue),
                      icon: Icons.savings_rounded,
                      accent: MetricAccent.emerald,
                      trendText: '+14.2%',
                      isPositiveTrend: true,
                    ),
                    GlassMetricCard(
                      title: 'Operational Cost',
                      value: CurrencyFormatter.formatBDT(summary.totalExpenses),
                      icon: Icons.receipt_long_rounded,
                      accent: MetricAccent.crimson,
                      trendText: '-2.1%',
                      isPositiveTrend: true,
                    ),
                    GlassMetricCard(
                      title: 'Net Profit Flow',
                      value: CurrencyFormatter.formatBDT(summary.netProfit),
                      icon: Icons.account_balance_rounded,
                      accent: summary.netProfit >= 0 ? MetricAccent.blue : MetricAccent.crimson,
                      trendText: summary.netProfit >= 0 ? 'Surplus' : 'Deficit',
                      isPositiveTrend: summary.netProfit >= 0,
                    ),
                    GlassMetricCard(
                      title: 'Receivable Dues',
                      value: CurrencyFormatter.formatBDT(summary.totalOutstandingDue),
                      icon: Icons.warning_amber_rounded,
                      accent: MetricAccent.amber,
                      trendText: 'Overdue',
                      isPositiveTrend: false,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            // Velocity Chart
            GlassFinancialChart(
              weeklyRevenue: summary.todayRevenue * 7,
              weeklyExpense: summary.todayExpense * 7,
            ),
            const SizedBox(height: 24),
            // Categorical Expense Breakdown
            LiquidGlassContainer(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Categorical Expenditure Breakdown', style: AppTypography.titleSmall),
                  const SizedBox(height: 4),
                  Text('Distribution of garage maintenance and fixed overheads', style: AppTypography.bodySmall),
                  const SizedBox(height: 16),
                  ...ExpenseCategory.values.map((cat) {
                    final amount = categoryBreakdown[cat] ?? 0.0;
                    final total = summary.totalExpenses > 0 ? summary.totalExpenses : 1.0;
                    final pct = (amount / total).clamp(0.0, 1.0);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_getCategoryTitle(cat), style: AppTypography.bodyMedium),
                              Text(CurrencyFormatter.formatBDT(amount), style: AppTypography.financialAmount.copyWith(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: pct,
                              minHeight: 6,
                              backgroundColor: Colors.white.withOpacity(0.08),
                              valueColor: AlwaysStoppedAnimation<Color>(_getCategoryColor(cat)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  String _getCategoryTitle(ExpenseCategory cat) {
    switch (cat) {
      case ExpenseCategory.mechanic: return 'Mechanic & Labor Charges';
      case ExpenseCategory.parts: return 'Spare Parts & Battery Maintenance';
      case ExpenseCategory.rent: return 'Garage Rent & Electric Charging';
      case ExpenseCategory.line_fee: return 'Union / Route Licensing';
      case ExpenseCategory.other: return 'Miscellaneous Expenditures';
    }
  }

  Color _getCategoryColor(ExpenseCategory cat) {
    switch (cat) {
      case ExpenseCategory.mechanic: return AppColors.primaryBlue;
      case ExpenseCategory.parts: return AppColors.electricAmber;
      case ExpenseCategory.rent: return AppColors.primaryPurple;
      case ExpenseCategory.line_fee: return AppColors.accentCyan;
      case ExpenseCategory.other: return AppColors.textSecondary;
    }
  }
}
