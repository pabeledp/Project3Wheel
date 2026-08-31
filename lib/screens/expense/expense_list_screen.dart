import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_utils.dart';
import '../../models/expense_model.dart';
import '../../providers/expense_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/layout/responsive_layout_builder.dart';
import 'add_expense_screen.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  ExpenseCategory? _filterCat;

  @override
  Widget build(BuildContext context) {
    final expenseState = ref.watch(expenseProvider);
    final currentUser = ref.watch(authProvider).currentUser;

    final filtered = expenseState.expenses.where((e) {
      return _filterCat == null || e.category == _filterCat;
    }).toList();

    return LiquidGlassBackgroundScaffold(
      appBar: AppBar(
        title: Text('Garage Expenses', style: AppTypography.titleMedium),
        actions: [
          PopupMenuButton<ExpenseCategory?>(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
            color: AppColors.backgroundElevated,
            onSelected: (cat) => setState(() => _filterCat = cat),
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('All Categories')),
              ...ExpenseCategory.values.map((c) => PopupMenuItem(value: c, child: Text(c.name.toUpperCase()))),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.crimsonRed,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Expense', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Header Stats Banner
            LiquidGlassContainer(
              padding: const EdgeInsets.all(16),
              color: AppColors.glassDarkLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Expenditures', style: AppTypography.labelSmall),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.formatBDT(filtered.fold(0, (s, e) => s + e.amount)),
                        style: AppTypography.financialAmount.copyWith(color: AppColors.crimsonRedLight, fontSize: 18),
                      ),
                    ],
                  ),
                  Text('${filtered.length} Incurred Logs', style: AppTypography.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.receipt_outlined, size: 48, color: AppColors.textTertiary),
                          const SizedBox(height: 12),
                          Text('No expense records logged', style: AppTypography.bodyMedium),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 90),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final e = filtered[index];
                        return LiquidGlassContainer(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: AppColors.crimsonGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(_getCategoryIcon(e.category), color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.categoryDisplayName, style: AppTypography.titleSmall),
                                    const SizedBox(height: 2),
                                    Text(
                                      e.note,
                                      style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${AppDateUtils.formatDate(e.date)} • Logged by ${e.recordedBy}',
                                      style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textTertiary),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    CurrencyFormatter.formatBDT(e.amount),
                                    style: AppTypography.financialAmount.copyWith(
                                      color: AppColors.crimsonRedLight,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (currentUser.isOwner)
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: AppColors.crimsonRed, size: 16),
                                      onPressed: () => ref.read(expenseProvider.notifier).deleteExpense(e.id),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(ExpenseCategory cat) {
    switch (cat) {
      case ExpenseCategory.mechanic: return Icons.build_rounded;
      case ExpenseCategory.parts: return Icons.settings_rounded;
      case ExpenseCategory.rent: return Icons.electric_bolt_rounded;
      case ExpenseCategory.line_fee: return Icons.badge_rounded;
      case ExpenseCategory.other: return Icons.more_horiz_rounded;
    }
  }
}
