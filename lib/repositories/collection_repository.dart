import 'package:uuid/uuid.dart';
import '../../models/collection_model.dart';
import '../../models/sync_record_model.dart';
import '../services/storage/hive_service.dart';
import '../services/sync/sync_engine.dart';

class CollectionRepository {
  final HiveService _hive = HiveService();
  final SyncEngine _syncEngine = SyncEngine();
  final Uuid _uuid = const Uuid();

  List<CollectionModel> getAll() => _hive.getAllCollections();

  List<CollectionModel> getForDate(DateTime date) {
    final all = _hive.getAllCollections();
    return all.where((c) =>
      c.date.year == date.year &&
      c.date.month == date.month &&
      c.date.day == date.day
    ).toList();
  }

  Future<CollectionModel> recordCollection({
    required String rickshawId,
    required String driverId,
    required String driverName,
    required double expectedAmount,
    required double paidAmount,
    required String recordedBy,
    DateTime? customDate,
  }) async {
    final due = expectedAmount - paidAmount;
    final status = due <= 0
        ? PaymentStatus.paid
        : (paidAmount > 0 ? PaymentStatus.due : PaymentStatus.unpaid);

    final collection = CollectionModel(
      id: 'COL-${DateTime.now().millisecondsSinceEpoch}-${_uuid.v4().substring(0, 4)}',
      date: customDate ?? DateTime.now(),
      rickshawId: rickshawId,
      driverId: driverId,
      driverName: driverName,
      expectedAmount: expectedAmount,
      paidAmount: paidAmount,
      dueAmount: due > 0 ? due : 0.0,
      paymentStatus: status,
      recordedBy: recordedBy,
      isSynced: false,
      createdAt: DateTime.now(),
    );

    // Save to Hive
    await _hive.saveCollection(collection);

    // Update Driver's total dues
    final driver = _hive.getDriver(driverId);
    if (driver != null) {
      final updatedDue = (driver.totalDue + (due > 0 ? due : 0.0)).clamp(0.0, double.infinity);
      await _hive.saveDriver(driver.copyWith(totalDue: updatedDue));
    }

    // Enqueue cloud sync
    await _syncEngine.enqueueOperation(
      id: collection.id,
      collectionName: 'daily_collections',
      action: SyncAction.create,
      payload: collection.toMap(),
    );

    return collection;
  }

  Future<void> deleteCollection(String id) async {
    await _hive.deleteCollection(id);
    await _syncEngine.enqueueOperation(
      id: id,
      collectionName: 'daily_collections',
      action: SyncAction.delete,
      payload: {},
    );
  }
}
