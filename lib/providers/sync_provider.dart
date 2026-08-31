import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/connectivity_service.dart';
import '../../services/sync/sync_engine.dart';
import '../../services/storage/hive_service.dart';

class SyncState {
  final NetworkStatus networkStatus;
  final int pendingCount;
  final bool isSyncing;

  const SyncState({
    required this.networkStatus,
    required this.pendingCount,
    this.isSyncing = false,
  });

  bool get isOnline => networkStatus == NetworkStatus.online;
  bool get hasPendingSync => pendingCount > 0;

  SyncState copyWith({
    NetworkStatus? networkStatus,
    int? pendingCount,
    bool? isSyncing,
  }) {
    return SyncState(
      networkStatus: networkStatus ?? this.networkStatus,
      pendingCount: pendingCount ?? this.pendingCount,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

class SyncNotifier extends StateNotifier<SyncState> {
  final ConnectivityService _connectivity = ConnectivityService();
  final SyncEngine _syncEngine = SyncEngine();
  final HiveService _hive = HiveService();

  SyncNotifier()
      : super(
          SyncState(
            networkStatus: ConnectivityService().currentStatus,
            pendingCount: HiveService().pendingSyncCount,
          ),
        ) {
    _init();
  }

  void _init() {
    _connectivity.statusStream.listen((status) {
      state = state.copyWith(networkStatus: status);
    });

    _syncEngine.pendingCountStream.listen((count) {
      state = state.copyWith(
        pendingCount: count,
        isSyncing: _syncEngine.isSyncing,
      );
    });
  }

  Future<void> triggerManualSync() async {
    state = state.copyWith(isSyncing: true);
    await _syncEngine.syncPendingRecords();
    state = state.copyWith(
      pendingCount: _hive.pendingSyncCount,
      isSyncing: false,
    );
  }

  void toggleSimulatedOffline() {
    if (state.isOnline) {
      _connectivity.setManualStatus(NetworkStatus.offline);
    } else {
      _connectivity.setManualStatus(NetworkStatus.online);
    }
  }
}

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier();
});
