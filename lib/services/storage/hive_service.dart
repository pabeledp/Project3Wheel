import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/collection_model.dart';
import '../../models/expense_model.dart';
import '../../models/driver_model.dart';
import '../../models/rickshaw_model.dart';
import '../../models/sms_log_model.dart';
import '../../models/sync_record_model.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  static const String boxCollections = 'collections_box';
  static const String boxExpenses = 'expenses_box';
  static const String boxDrivers = 'drivers_box';
  static const String boxRickshaws = 'rickshaws_box';
  static const String boxSyncQueue = 'sync_queue_box';
  static const String boxSmsLogs = 'sms_logs_box';
  static const String boxSettings = 'settings_box';

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await Hive.initFlutter();
      await Hive.openBox(boxCollections);
      await Hive.openBox(boxExpenses);
      await Hive.openBox(boxDrivers);
      await Hive.openBox(boxRickshaws);
      await Hive.openBox(boxSyncQueue);
      await Hive.openBox(boxSmsLogs);
      await Hive.openBox(boxSettings);
      _isInitialized = true;
      debugPrint('Hive initialized successfully with all local boxes.');
    } catch (e) {
      debugPrint('Hive init error: $e');
    }
  }

  // --- Collections ---
  Future<void> saveCollection(CollectionModel item) async {
    final box = Hive.box(boxCollections);
    await box.put(item.id, item.toMap());
  }

  List<CollectionModel> getAllCollections() {
    final box = Hive.box(boxCollections);
    final list = <CollectionModel>[];
    for (var key in box.keys) {
      final val = box.get(key);
      if (val is Map) {
        list.add(CollectionModel.fromMap(Map<String, dynamic>.from(val)));
      }
    }
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<void> deleteCollection(String id) async {
    final box = Hive.box(boxCollections);
    await box.delete(id);
  }

  // --- Expenses ---
  Future<void> saveExpense(ExpenseModel item) async {
    final box = Hive.box(boxExpenses);
    await box.put(item.id, item.toMap());
  }

  List<ExpenseModel> getAllExpenses() {
    final box = Hive.box(boxExpenses);
    final list = <ExpenseModel>[];
    for (var key in box.keys) {
      final val = box.get(key);
      if (val is Map) {
        list.add(ExpenseModel.fromMap(Map<String, dynamic>.from(val)));
      }
    }
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<void> deleteExpense(String id) async {
    final box = Hive.box(boxExpenses);
    await box.delete(id);
  }

  // --- Drivers ---
  Future<void> saveDriver(DriverModel driver) async {
    final box = Hive.box(boxDrivers);
    await box.put(driver.driverId, driver.toMap());
  }

  List<DriverModel> getAllDrivers() {
    final box = Hive.box(boxDrivers);
    final list = <DriverModel>[];
    for (var key in box.keys) {
      final val = box.get(key);
      if (val is Map) {
        list.add(DriverModel.fromMap(Map<String, dynamic>.from(val)));
      }
    }
    list.sort((a, b) => a.driverId.compareTo(b.driverId));
    return list;
  }

  DriverModel? getDriver(String driverId) {
    final box = Hive.box(boxDrivers);
    final val = box.get(driverId);
    if (val is Map) {
      return DriverModel.fromMap(Map<String, dynamic>.from(val));
    }
    return null;
  }

  // --- Rickshaws ---
  Future<void> saveRickshaw(RickshawModel r) async {
    final box = Hive.box(boxRickshaws);
    await box.put(r.rickshawId, r.toMap());
  }

  List<RickshawModel> getAllRickshaws() {
    final box = Hive.box(boxRickshaws);
    final list = <RickshawModel>[];
    for (var key in box.keys) {
      final val = box.get(key);
      if (val is Map) {
        list.add(RickshawModel.fromMap(Map<String, dynamic>.from(val)));
      }
    }
    list.sort((a, b) => a.rickshawId.compareTo(b.rickshawId));
    return list;
  }

  RickshawModel? getRickshaw(String rickshawId) {
    final box = Hive.box(boxRickshaws);
    final val = box.get(rickshawId);
    if (val is Map) {
      return RickshawModel.fromMap(Map<String, dynamic>.from(val));
    }
    return null;
  }

  Future<void> deleteRickshaw(String rickshawId) async {
    final box = Hive.box(boxRickshaws);
    await box.delete(rickshawId);
  }

  Future<void> deleteDriver(String driverId) async {
    final box = Hive.box(boxDrivers);
    await box.delete(driverId);
  }

  // --- SMS Logs ---
  Future<void> saveSmsLog(SmsLogModel log) async {
    final box = Hive.box(boxSmsLogs);
    await box.put(log.logId, log.toMap());
  }

  List<SmsLogModel> getAllSmsLogs() {
    final box = Hive.box(boxSmsLogs);
    final list = <SmsLogModel>[];
    for (var key in box.keys) {
      final val = box.get(key);
      if (val is Map) {
        list.add(SmsLogModel.fromMap(Map<String, dynamic>.from(val)));
      }
    }
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  // --- Sync Queue ---
  Future<void> enqueueSync(SyncRecordModel record) async {
    final box = Hive.box(boxSyncQueue);
    await box.put(record.id, record.toMap());
  }

  List<SyncRecordModel> getPendingSyncQueue() {
    final box = Hive.box(boxSyncQueue);
    final list = <SyncRecordModel>[];
    for (var key in box.keys) {
      final val = box.get(key);
      if (val is Map) {
        list.add(SyncRecordModel.fromMap(Map<String, dynamic>.from(val)));
      }
    }
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }

  Future<void> removeSyncRecord(String id) async {
    final box = Hive.box(boxSyncQueue);
    await box.delete(id);
  }

  int get pendingSyncCount => Hive.box(boxSyncQueue).length;

  // --- Account Credentials ---
  Future<void> saveAccountCredential(String identifier, String password, String name, String role) async {
    final box = Hive.box(boxSettings);
    final accounts = Map<String, dynamic>.from(box.get('registered_accounts', defaultValue: <String, dynamic>{}));
    accounts[identifier.toLowerCase().trim()] = {
      'password': password,
      'name': name,
      'role': role,
    };
    await box.put('registered_accounts', accounts);
  }

  Map<String, dynamic>? getAccountCredential(String identifier) {
    final box = Hive.box(boxSettings);
    final accounts = Map<String, dynamic>.from(box.get('registered_accounts', defaultValue: <String, dynamic>{}));
    final acc = accounts[identifier.toLowerCase().trim()];
    if (acc is Map) {
      return Map<String, dynamic>.from(acc);
    }
    return null;
  }

  // --- Persistent Active Session ---
  Future<void> saveActiveSession(Map<String, dynamic> userMap) async {
    final box = Hive.box(boxSettings);
    await box.put('active_user_session', userMap);
  }

  Map<String, dynamic>? getActiveSession() {
    final box = Hive.box(boxSettings);
    final session = box.get('active_user_session');
    if (session is Map) {
      return Map<String, dynamic>.from(session);
    }
    return null;
  }

  Future<void> clearActiveSession() async {
    final box = Hive.box(boxSettings);
    await box.delete('active_user_session');
  }
}
