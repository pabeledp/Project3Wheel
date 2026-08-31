import 'package:uuid/uuid.dart';
import '../../models/expense_model.dart';
import '../../models/sync_record_model.dart';
import '../services/storage/hive_service.dart';
import '../services/sync/sync_engine.dart';

class ExpenseRepository {
  final HiveService _hive = HiveService();
  final SyncEngine _syncEngine = SyncEngine();
  final Uuid _uuid = const Uuid();

  List<ExpenseModel> getAll() => _hive.getAllExpenses();

  List<ExpenseModel> getForDate(DateTime date) {
    final all = _hive.getAllExpenses();
    return all.where((e) =>
      e.date.year == date.year &&
      e.date.month == date.month &&
      e.date.day == date.day
    ).toList();
  }

  Future<ExpenseModel> recordExpense({
    required ExpenseCategory category,
    required double amount,
    required String note,
    required String recordedBy,
    String? receiptImageUrl,
    DateTime? customDate,
  }) async {
    final expense = ExpenseModel(
      id: 'EXP-${DateTime.now().millisecondsSinceEpoch}-${_uuid.v4().substring(0, 4)}',
      date: customDate ?? DateTime.now(),
      category: category,
      amount: amount,
      receiptImageUrl: receiptImageUrl,
      note: note,
      recordedBy: recordedBy,
      isSynced: false,
      createdAt: DateTime.now(),
    );

    await _hive.saveExpense(expense);

    await _syncEngine.enqueueOperation(
      id: expense.id,
      collectionName: 'expenses',
      action: SyncAction.create,
      payload: expense.toMap(),
    );

    return expense;
  }

  Future<void> deleteExpense(String id) async {
    await _hive.deleteExpense(id);
    await _syncEngine.enqueueOperation(
      id: id,
      collectionName: 'expenses',
      action: SyncAction.delete,
      payload: {},
    );
  }
}
