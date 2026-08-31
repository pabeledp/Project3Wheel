import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/expense_model.dart';
import '../../repositories/expense_repository.dart';

class ExpenseState {
  final List<ExpenseModel> expenses;
  final bool isLoading;

  const ExpenseState({
    this.expenses = const [],
    this.isLoading = false,
  });

  List<ExpenseModel> get todayExpenses {
    final now = DateTime.now();
    return expenses.where((e) =>
      e.date.year == now.year &&
      e.date.month == now.month &&
      e.date.day == now.day
    ).toList();
  }

  double get todayExpenseTotal =>
      todayExpenses.fold<double>(0, (sum, e) => sum + e.amount);

  double get totalExpensesAllTime =>
      expenses.fold<double>(0, (sum, e) => sum + e.amount);

  Map<ExpenseCategory, double> get categoryBreakdown {
    final map = <ExpenseCategory, double>{};
    for (var e in expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  ExpenseState copyWith({
    List<ExpenseModel>? expenses,
    bool? isLoading,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ExpenseNotifier extends StateNotifier<ExpenseState> {
  final ExpenseRepository _repo = ExpenseRepository();

  ExpenseNotifier() : super(const ExpenseState()) {
    refresh();
  }

  void refresh() {
    state = state.copyWith(isLoading: true);
    final list = _repo.getAll();
    state = state.copyWith(
      expenses: list,
      isLoading: false,
    );
  }

  Future<ExpenseModel> recordExpense({
    required ExpenseCategory category,
    required double amount,
    required String note,
    required String recordedBy,
    String? receiptImageUrl,
    DateTime? customDate,
  }) async {
    final result = await _repo.recordExpense(
      category: category,
      amount: amount,
      note: note,
      recordedBy: recordedBy,
      receiptImageUrl: receiptImageUrl,
      customDate: customDate,
    );

    refresh();
    return result;
  }

  Future<void> deleteExpense(String id) async {
    await _repo.deleteExpense(id);
    refresh();
  }
}

final expenseProvider = StateNotifierProvider<ExpenseNotifier, ExpenseState>((ref) {
  return ExpenseNotifier();
});
