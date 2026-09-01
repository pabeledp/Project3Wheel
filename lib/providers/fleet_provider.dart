import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/rickshaw_model.dart';
import '../../models/driver_model.dart';
import '../../repositories/rickshaw_repository.dart';
import '../../repositories/driver_repository.dart';

class FleetState {
  final List<RickshawModel> rickshaws;
  final List<DriverModel> drivers;
  final bool isLoading;

  const FleetState({
    this.rickshaws = const [],
    this.drivers = const [],
    this.isLoading = false,
  });

  int get totalRickshaws => rickshaws.length;
  int get activeRickshaws => rickshaws.where((r) => r.isActive).length;
  int get maintenanceRickshaws => rickshaws.where((r) => r.isInMaintenance).length;

  int get totalDrivers => drivers.length;
  int get defaultersCount => drivers.where((d) => d.hasDue).length;
  double get totalOutstandingDue => drivers.fold<double>(0, (sum, d) => sum + d.totalDue);

  FleetState copyWith({
    List<RickshawModel>? rickshaws,
    List<DriverModel>? drivers,
    bool? isLoading,
  }) {
    return FleetState(
      rickshaws: rickshaws ?? this.rickshaws,
      drivers: drivers ?? this.drivers,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class FleetNotifier extends StateNotifier<FleetState> {
  final RickshawRepository _rickshawRepo = RickshawRepository();
  final DriverRepository _driverRepo = DriverRepository();

  FleetNotifier() : super(const FleetState()) {
    refresh();
  }

  void refresh() {
    state = state.copyWith(isLoading: true);
    final rList = _rickshawRepo.getAll();
    final dList = _driverRepo.getAll();
    state = state.copyWith(
      rickshaws: rList,
      drivers: dList,
      isLoading: false,
    );
  }

  Future<void> updateRickshawStatus(String id, RickshawStatus status) async {
    await _rickshawRepo.updateStatus(id, status);
    refresh();
  }

  Future<void> addRickshaw(RickshawModel rickshaw) async {
    await _rickshawRepo.save(rickshaw);
    refresh();
  }

  Future<void> deleteRickshaw(String rickshawId) async {
    await _rickshawRepo.delete(rickshawId);
    refresh();
  }

  Future<void> saveDriver(DriverModel driver) async {
    await _driverRepo.save(driver);
    refresh();
  }

  Future<void> addDriver(DriverModel driver) async {
    await _driverRepo.save(driver);
    refresh();
  }

  Future<void> deleteDriver(String driverId) async {
    // If assigned to a rickshaw, detach
    final driver = _driverRepo.getById(driverId);
    if (driver?.activeRickshawId != null) {
      final r = _rickshawRepo.getById(driver!.activeRickshawId!);
      if (r != null) {
        await _rickshawRepo.save(r.copyWith(assignedDriverId: null));
      }
    }
    await _driverRepo.delete(driverId);
    refresh();
  }
}

final fleetProvider = StateNotifierProvider<FleetNotifier, FleetState>((ref) {
  return FleetNotifier();
});
