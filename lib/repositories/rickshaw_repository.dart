import '../../models/rickshaw_model.dart';
import '../../models/sync_record_model.dart';
import '../services/storage/hive_service.dart';
import '../services/sync/sync_engine.dart';

class RickshawRepository {
  final HiveService _hive = HiveService();
  final SyncEngine _syncEngine = SyncEngine();

  List<RickshawModel> getAll() => _hive.getAllRickshaws();

  RickshawModel? getById(String id) => _hive.getRickshaw(id);

  RickshawModel? getByQrCode(String qr) {
    final all = _hive.getAllRickshaws();
    return all.cast<RickshawModel?>().firstWhere(
      (r) => r?.qrCode.toLowerCase() == qr.trim().toLowerCase() ||
             r?.rickshawId.toLowerCase() == qr.trim().toLowerCase(),
      orElse: () => null,
    );
  }

  Future<void> save(RickshawModel rickshaw) async {
    await _hive.saveRickshaw(rickshaw);
    await _syncEngine.enqueueOperation(
      id: rickshaw.rickshawId,
      collectionName: 'rickshaws',
      action: SyncAction.update,
      payload: rickshaw.toMap(),
    );
  }

  Future<void> updateStatus(String rickshawId, RickshawStatus status) async {
    final rickshaw = _hive.getRickshaw(rickshawId);
    if (rickshaw != null) {
      final updated = rickshaw.copyWith(status: status);
      await save(updated);
    }
  }

  Future<void> delete(String rickshawId) async {
    await _hive.deleteRickshaw(rickshawId);
    await _syncEngine.enqueueOperation(
      id: rickshawId,
      collectionName: 'rickshaws',
      action: SyncAction.delete,
      payload: {'id': rickshawId},
    );
  }

  Future<void> updateLocation(String rickshawId, LastLocation location) async {
    final rickshaw = _hive.getRickshaw(rickshawId);
    if (rickshaw != null) {
      final updated = rickshaw.copyWith(lastLocation: location);
      await save(updated);
    }
  }
}
