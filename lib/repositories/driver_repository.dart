import '../../models/driver_model.dart';
import '../../models/sync_record_model.dart';
import '../services/storage/hive_service.dart';
import '../services/sync/sync_engine.dart';
import 'package:hive/hive.dart';

class DriverRepository {
  final HiveService _hive = HiveService();
  final SyncEngine _syncEngine = SyncEngine();

  List<DriverModel> getAll() => _hive.getAllDrivers();

  DriverModel? getById(String id) => _hive.getDriver(id);

  List<DriverModel> getDefaulters() {
    final all = _hive.getAllDrivers();
    return all.where((d) => d.totalDue > 0).toList()
      ..sort((a, b) => b.totalDue.compareTo(a.totalDue));
  }

  Future<void> save(DriverModel driver) async {
    await _hive.saveDriver(driver);
    await _syncEngine.enqueueOperation(
      id: driver.driverId,
      collectionName: 'drivers',
      action: SyncAction.update,
      payload: driver.toMap(),
    );
  }

  Future<void> delete(String driverId) async {
    final box = Hive.box(HiveService.boxDrivers);
    await box.delete(driverId);
    await _syncEngine.enqueueOperation(
      id: driverId,
      collectionName: 'drivers',
      action: SyncAction.delete,
      payload: {},
    );
  }

  Future<void> adjustDue(String driverId, double newDue) async {
    final driver = _hive.getDriver(driverId);
    if (driver != null) {
      final updated = driver.copyWith(totalDue: newDue.clamp(0.0, double.infinity));
      await save(updated);
    }
  }
}
