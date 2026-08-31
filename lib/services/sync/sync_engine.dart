import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../storage/hive_service.dart';
import '../../core/network/connectivity_service.dart';
import '../../models/sync_record_model.dart';
import '../../models/collection_model.dart';
import '../../models/expense_model.dart';

class SyncEngine {
  static final SyncEngine _instance = SyncEngine._internal();
  factory SyncEngine() => _instance;
  SyncEngine._internal();

  final HiveService _hive = HiveService();
  final ConnectivityService _connectivity = ConnectivityService();

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  final StreamController<int> _pendingCountController = StreamController<int>.broadcast();
  Stream<int> get pendingCountStream => _pendingCountController.stream;

  void initialize() {
    _connectivity.statusStream.listen((status) {
      if (status == NetworkStatus.online) {
        debugPrint('[SyncEngine] Network online detected. Triggering auto-sync...');
        syncPendingRecords();
      }
    });
    _notifyPendingCount();
  }

  void _notifyPendingCount() {
    _pendingCountController.add(_hive.pendingSyncCount);
  }

  Future<void> syncPendingRecords() async {
    if (_isSyncing) return;
    if (!_connectivity.isOnline) return;

    final pending = _hive.getPendingSyncQueue();
    if (pending.isEmpty) {
      _notifyPendingCount();
      return;
    }

    _isSyncing = true;
    debugPrint('[SyncEngine] Syncing ${pending.length} pending items to Firestore...');

    try {
      // Check if Firebase is available
      final firestore = FirebaseFirestore.instance;

      for (var record in pending) {
        try {
          final docRef = firestore.collection(record.collectionName).doc(record.id);

          switch (record.action) {
            case SyncAction.create:
            case SyncAction.update:
              await docRef.set(record.payload, SetOptions(merge: true));
              break;
            case SyncAction.delete:
              await docRef.delete();
              break;
          }

          // Mark local records as synced
          if (record.collectionName == 'daily_collections') {
            final col = CollectionModel.fromMap(record.payload).copyWith(isSynced: true);
            await _hive.saveCollection(col);
          } else if (record.collectionName == 'expenses') {
            final exp = ExpenseModel.fromMap(record.payload).copyWith(isSynced: true);
            await _hive.saveExpense(exp);
          }

          await _hive.removeSyncRecord(record.id);
          debugPrint('[SyncEngine] Synced record: ${record.collectionName}/${record.id}');
        } catch (itemError) {
          debugPrint('[SyncEngine] Failed record sync ${record.id}: $itemError');
          // Increment retry count
          final updated = record.copyWith(retryCount: record.retryCount + 1);
          await _hive.enqueueSync(updated);
        }
      }
    } catch (e) {
      debugPrint('[SyncEngine] Firestore sync batch error: $e');
    } finally {
      _isSyncing = false;
      _notifyPendingCount();
    }
  }

  /// Queue an offline write
  Future<void> enqueueOperation({
    required String id,
    required String collectionName,
    required SyncAction action,
    required Map<String, dynamic> payload,
  }) async {
    final record = SyncRecordModel(
      id: id,
      collectionName: collectionName,
      action: action,
      payload: payload,
      timestamp: DateTime.now(),
    );
    await _hive.enqueueSync(record);
    _notifyPendingCount();

    if (_connectivity.isOnline) {
      syncPendingRecords();
    }
  }
}
