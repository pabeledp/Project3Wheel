import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'collection_provider.dart';
import 'expense_provider.dart';
import 'fleet_provider.dart';

class FinancialSummary {
  final double todayRevenue;
  final double todayExpense;
  final double todayNetCashFlow;
  final double totalRevenue;
  final double totalExpenses;
  final double netProfit;
  final double totalOutstandingDue;
  final double collectionRate;

  const FinancialSummary({
    required this.todayRevenue,
    required this.todayExpense,
    required this.todayNetCashFlow,
    required this.totalRevenue,
    required this.totalExpenses,
    required this.netProfit,
    required this.totalOutstandingDue,
    required this.collectionRate,
  });
}

final financialSummaryProvider = Provider<FinancialSummary>((ref) {
  final collectionState = ref.watch(collectionProvider);
  final expenseState = ref.watch(expenseProvider);
  final fleetState = ref.watch(fleetProvider);

  final todayRev = collectionState.todayCollectedTotal;
  final todayExp = expenseState.todayExpenseTotal;
  final todayNet = todayRev - todayExp;

  final totalRev = collectionState.collections.fold<double>(0, (sum, c) => sum + c.paidAmount);
  final totalExp = expenseState.totalExpensesAllTime;
  final netProf = totalRev - totalExp;

  final totalExpTarget = collectionState.todayExpectedTotal;
  final rate = totalExpTarget > 0 ? (todayRev / totalExpTarget * 100).clamp(0.0, 100.0) : 0.0;

  return FinancialSummary(
    todayRevenue: todayRev,
    todayExpense: todayExp,
    todayNetCashFlow: todayNet,
    totalRevenue: totalRev,
    totalExpenses: totalExp,
    netProfit: netProf,
    totalOutstandingDue: fleetState.totalOutstandingDue,
    collectionRate: rate,
  );
});
