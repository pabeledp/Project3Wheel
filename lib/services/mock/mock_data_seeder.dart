import 'package:flutter/foundation.dart';
import '../../models/rickshaw_model.dart';
import '../../models/driver_model.dart';
import '../storage/hive_service.dart';

class MockDataSeeder {
  MockDataSeeder._();

  static Future<void> seedIfEmpty() async {
    final hive = HiveService();
    if (!hive.isInitialized) await hive.initialize();

    final existingRickshaws = hive.getAllRickshaws();
    if (existingRickshaws.isNotEmpty) {
      debugPrint('[MockDataSeeder] Real assigned fleet dataset already initialized. Skipping.');
      return;
    }

    debugPrint('[MockDataSeeder] Initializing clean real assigned fleet...');

    // 1. Initial Real Fleet (Clean registered vehicles)
    final rickshaws = [
      RickshawModel(
        rickshawId: 'R-01',
        qrCode: 'R-01',
        status: RickshawStatus.active,
        deviceImei: '864201048291001',
        dailyRentRate: 350.0,
        assignedDriverId: 'D-101',
        modelName: 'Mishuk Classic 48V',
        lastLocation: LastLocation(lat: 23.8103, lng: 90.4125, speed: 18.5, updatedAt: DateTime.now()),
      ),
      RickshawModel(
        rickshawId: 'R-02',
        qrCode: 'R-02',
        status: RickshawStatus.active,
        deviceImei: '864201048291002',
        dailyRentRate: 350.0,
        assignedDriverId: 'D-102',
        modelName: 'Speedy Eco 60V',
        lastLocation: LastLocation(lat: 23.8050, lng: 90.3690, speed: 22.0, updatedAt: DateTime.now()),
      ),
      RickshawModel(
        rickshawId: 'R-03',
        qrCode: 'R-03',
        status: RickshawStatus.maintenance,
        deviceImei: '864201048291003',
        dailyRentRate: 350.0,
        assignedDriverId: null,
        modelName: 'Runner Turbo 48V',
        lastLocation: LastLocation(lat: 23.7925, lng: 90.4078, speed: 0.0, updatedAt: DateTime.now()),
      ),
    ];

    for (var r in rickshaws) {
      await hive.saveRickshaw(r);
    }

    // 2. Initial Real Assigned Drivers (Clean, zero dummy dues)
    final drivers = [
      DriverModel(
        driverId: 'D-101',
        name: 'Karim Ullah',
        phone: '01711223344',
        nid: '19882691234567890',
        totalDue: 0.0,
        activeRickshawId: 'R-01',
        address: 'Mirpur-10, Dhaka',
        joinedDate: DateTime.now(),
      ),
      DriverModel(
        driverId: 'D-102',
        name: 'Rafiqul Islam',
        phone: '01812345678',
        nid: '19922699876543210',
        totalDue: 0.0,
        activeRickshawId: 'R-02',
        address: 'Kalyanpur, Dhaka',
        joinedDate: DateTime.now(),
      ),
    ];

    for (var d in drivers) {
      await hive.saveDriver(d);
    }

    debugPrint('[MockDataSeeder] Initialized clean fleet (${rickshaws.length} vehicles, ${drivers.length} drivers, 0 fake collections).');
  }
}
