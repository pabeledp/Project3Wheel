import 'package:flutter/foundation.dart';
import '../../models/rickshaw_model.dart';
import '../../models/driver_model.dart';
import '../../models/collection_model.dart';
import '../../models/expense_model.dart';
import '../../models/sms_log_model.dart';
import '../storage/hive_service.dart';

class MockDataSeeder {
  MockDataSeeder._();

  static Future<void> seedIfEmpty() async {
    final hive = HiveService();
    if (!hive.isInitialized) await hive.initialize();

    final existingRickshaws = hive.getAllRickshaws();
    if (existingRickshaws.isNotEmpty) {
      debugPrint('[MockDataSeeder] Data already exists (${existingRickshaws.length} rickshaws). Skipping seed.');
      return;
    }

    debugPrint('[MockDataSeeder] Empty local database detected. Seeding realistic Dhaka fleet dataset...');

    // 1. Seed Rickshaws (R-01 to R-15)
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
        status: RickshawStatus.active,
        deviceImei: '864201048291003',
        dailyRentRate: 350.0,
        assignedDriverId: 'D-103',
        modelName: 'Mishuk Classic 48V',
        lastLocation: LastLocation(lat: 23.7925, lng: 90.4078, speed: 0.0, updatedAt: DateTime.now()),
      ),
      RickshawModel(
        rickshawId: 'R-04',
        qrCode: 'R-04',
        status: RickshawStatus.maintenance,
        deviceImei: '864201048291004',
        dailyRentRate: 350.0,
        assignedDriverId: null,
        modelName: 'Runner Turbo 48V',
        lastLocation: LastLocation(lat: 23.8223, lng: 90.3654, speed: 0.0, updatedAt: DateTime.now()),
      ),
      RickshawModel(
        rickshawId: 'R-05',
        qrCode: 'R-05',
        status: RickshawStatus.active,
        deviceImei: '864201048291005',
        dailyRentRate: 380.0,
        assignedDriverId: 'D-104',
        modelName: 'GreenWheels Pro 60V',
        lastLocation: LastLocation(lat: 23.7808, lng: 90.4192, speed: 15.2, updatedAt: DateTime.now()),
      ),
      RickshawModel(
        rickshawId: 'R-06',
        qrCode: 'R-06',
        status: RickshawStatus.active,
        deviceImei: '864201048291006',
        dailyRentRate: 350.0,
        assignedDriverId: 'D-105',
        modelName: 'Mishuk Classic 48V',
        lastLocation: LastLocation(lat: 23.8340, lng: 90.3580, speed: 19.8, updatedAt: DateTime.now()),
      ),
      RickshawModel(
        rickshawId: 'R-07',
        qrCode: 'R-07',
        status: RickshawStatus.active,
        deviceImei: '864201048291007',
        dailyRentRate: 350.0,
        assignedDriverId: 'D-106',
        modelName: 'Mishuk Classic 48V',
        lastLocation: LastLocation(lat: 23.7500, lng: 90.3900, speed: 14.1, updatedAt: DateTime.now()),
      ),
      RickshawModel(
        rickshawId: 'R-08',
        qrCode: 'R-08',
        status: RickshawStatus.maintenance,
        deviceImei: '864201048291008',
        dailyRentRate: 350.0,
        assignedDriverId: null,
        modelName: 'Speedy Eco 60V',
        lastLocation: LastLocation(lat: 23.8100, lng: 90.3700, speed: 0.0, updatedAt: DateTime.now()),
      ),
      RickshawModel(
        rickshawId: 'R-09',
        qrCode: 'R-09',
        status: RickshawStatus.active,
        deviceImei: '864201048291009',
        dailyRentRate: 350.0,
        assignedDriverId: 'D-107',
        modelName: 'Mishuk Classic 48V',
        lastLocation: LastLocation(lat: 23.8650, lng: 90.3950, speed: 21.4, updatedAt: DateTime.now()),
      ),
      RickshawModel(
        rickshawId: 'R-10',
        qrCode: 'R-10',
        status: RickshawStatus.active,
        deviceImei: '864201048291010',
        dailyRentRate: 400.0,
        assignedDriverId: 'D-108',
        modelName: 'Speedy Heavy Duty 72V',
        lastLocation: LastLocation(lat: 23.7700, lng: 90.3600, speed: 12.6, updatedAt: DateTime.now()),
      ),
    ];

    for (var r in rickshaws) {
      await hive.saveRickshaw(r);
    }

    // 2. Seed Drivers
    final drivers = [
      DriverModel(
        driverId: 'D-101',
        name: 'Karim Ullah',
        phone: '01711223344',
        nid: '19882691234567890',
        totalDue: 0.0,
        activeRickshawId: 'R-01',
        address: 'Mirpur-10, Dhaka',
        joinedDate: DateTime.now().subtract(const Duration(days: 180)),
      ),
      DriverModel(
        driverId: 'D-102',
        name: 'Rafiqul Islam',
        phone: '01812345678',
        nid: '19922699876543210',
        totalDue: 700.0, // Defaulter
        activeRickshawId: 'R-02',
        address: 'Kalyanpur, Dhaka',
        joinedDate: DateTime.now().subtract(const Duration(days: 90)),
      ),
      DriverModel(
        driverId: 'D-103',
        name: 'Abul Hossain',
        phone: '01919876543',
        nid: '19852694561237890',
        totalDue: 350.0, // Partial due
        activeRickshawId: 'R-03',
        address: 'Gabtoli, Dhaka',
        joinedDate: DateTime.now().subtract(const Duration(days: 300)),
      ),
      DriverModel(
        driverId: 'D-104',
        name: 'Md. Shahjahan',
        phone: '01615554433',
        nid: '19902693214569870',
        totalDue: 1050.0, // High due
        activeRickshawId: 'R-05',
        address: 'Mohammadpur, Dhaka',
        joinedDate: DateTime.now().subtract(const Duration(days: 45)),
      ),
      DriverModel(
        driverId: 'D-105',
        name: 'Sattar Bepari',
        phone: '01718889900',
        nid: '19832696547891230',
        totalDue: 0.0,
        activeRickshawId: 'R-06',
        address: 'Badda, Dhaka',
        joinedDate: DateTime.now().subtract(const Duration(days: 400)),
      ),
      DriverModel(
        driverId: 'D-106',
        name: 'Billal Majhi',
        phone: '01512223344',
        nid: '19942697894561230',
        totalDue: 1400.0, // High defaulter
        activeRickshawId: 'R-07',
        address: 'Tejgaon, Dhaka',
        joinedDate: DateTime.now().subtract(const Duration(days: 60)),
      ),
      DriverModel(
        driverId: 'D-107',
        name: 'Jasim Shikdar',
        phone: '01314445566',
        nid: '19912691472583690',
        totalDue: 0.0,
        activeRickshawId: 'R-09',
        address: 'Uttara, Dhaka',
        joinedDate: DateTime.now().subtract(const Duration(days: 120)),
      ),
      DriverModel(
        driverId: 'D-108',
        name: 'Mokbul Sardar',
        phone: '01817778899',
        nid: '19872693692581470',
        totalDue: 400.0,
        activeRickshawId: 'R-10',
        address: 'Kazipara, Dhaka',
        joinedDate: DateTime.now().subtract(const Duration(days: 210)),
      ),
    ];

    for (var d in drivers) {
      await hive.saveDriver(d);
    }

    // 3. Seed Today's & Past Daily Collections
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final collections = [
      // Today
      CollectionModel(
        id: 'COL-TODAY-01',
        date: today,
        rickshawId: 'R-01',
        driverId: 'D-101',
        driverName: 'Karim Ullah',
        expectedAmount: 350.0,
        paidAmount: 350.0,
        dueAmount: 0.0,
        paymentStatus: PaymentStatus.paid,
        recordedBy: 'MGR-SELIM',
        isSynced: true,
        createdAt: today.add(const Duration(hours: 8, minutes: 15)),
      ),
      CollectionModel(
        id: 'COL-TODAY-02',
        date: today,
        rickshawId: 'R-02',
        driverId: 'D-102',
        driverName: 'Rafiqul Islam',
        expectedAmount: 350.0,
        paidAmount: 150.0,
        dueAmount: 200.0,
        paymentStatus: PaymentStatus.due,
        recordedBy: 'MGR-SELIM',
        isSynced: true,
        createdAt: today.add(const Duration(hours: 9, minutes: 30)),
      ),
      CollectionModel(
        id: 'COL-TODAY-03',
        date: today,
        rickshawId: 'R-03',
        driverId: 'D-103',
        driverName: 'Abul Hossain',
        expectedAmount: 350.0,
        paidAmount: 350.0,
        dueAmount: 0.0,
        paymentStatus: PaymentStatus.paid,
        recordedBy: 'MGR-SELIM',
        isSynced: true,
        createdAt: today.add(const Duration(hours: 10, minutes: 5)),
      ),
      CollectionModel(
        id: 'COL-TODAY-04',
        date: today,
        rickshawId: 'R-05',
        driverId: 'D-104',
        driverName: 'Md. Shahjahan',
        expectedAmount: 380.0,
        paidAmount: 0.0,
        dueAmount: 380.0,
        paymentStatus: PaymentStatus.unpaid,
        recordedBy: 'MGR-SELIM',
        isSynced: true,
        createdAt: today.add(const Duration(hours: 11, minutes: 0)),
      ),
      CollectionModel(
        id: 'COL-TODAY-05',
        date: today,
        rickshawId: 'R-06',
        driverId: 'D-105',
        driverName: 'Sattar Bepari',
        expectedAmount: 350.0,
        paidAmount: 350.0,
        dueAmount: 0.0,
        paymentStatus: PaymentStatus.paid,
        recordedBy: 'MGR-SELIM',
        isSynced: true,
        createdAt: today.add(const Duration(hours: 11, minutes: 45)),
      ),
      // Yesterday
      CollectionModel(
        id: 'COL-YEST-01',
        date: today.subtract(const Duration(days: 1)),
        rickshawId: 'R-01',
        driverId: 'D-101',
        driverName: 'Karim Ullah',
        expectedAmount: 350.0,
        paidAmount: 350.0,
        dueAmount: 0.0,
        paymentStatus: PaymentStatus.paid,
        recordedBy: 'MGR-SELIM',
        isSynced: true,
        createdAt: today.subtract(const Duration(days: 1)).add(const Duration(hours: 18)),
      ),
      CollectionModel(
        id: 'COL-YEST-02',
        date: today.subtract(const Duration(days: 1)),
        rickshawId: 'R-07',
        driverId: 'D-106',
        driverName: 'Billal Majhi',
        expectedAmount: 350.0,
        paidAmount: 0.0,
        dueAmount: 350.0,
        paymentStatus: PaymentStatus.unpaid,
        recordedBy: 'MGR-SELIM',
        isSynced: true,
        createdAt: today.subtract(const Duration(days: 1)).add(const Duration(hours: 19)),
      ),
    ];

    for (var c in collections) {
      await hive.saveCollection(c);
    }

    // 4. Seed Expenses
    final expenses = [
      ExpenseModel(
        id: 'EXP-01',
        date: today,
        category: ExpenseCategory.parts,
        amount: 1200.0,
        note: 'Purchased 2x Front Brake Shoes & Tube (R-04 servicing)',
        recordedBy: 'MGR-SELIM',
        isSynced: true,
        createdAt: today.add(const Duration(hours: 10, minutes: 20)),
      ),
      ExpenseModel(
        id: 'EXP-02',
        date: today,
        category: ExpenseCategory.mechanic,
        amount: 450.0,
        note: 'Master Ustad labor charge for R-08 motor axle repair',
        recordedBy: 'MGR-SELIM',
        isSynced: true,
        createdAt: today.add(const Duration(hours: 12, minutes: 10)),
      ),
      ExpenseModel(
        id: 'EXP-03',
        date: today.subtract(const Duration(days: 2)),
        category: ExpenseCategory.rent,
        amount: 3500.0,
        note: 'Monthly commercial electricity meter advance for charging station',
        recordedBy: 'OWNER-HABIB',
        isSynced: true,
        createdAt: today.subtract(const Duration(days: 2)),
      ),
      ExpenseModel(
        id: 'EXP-04',
        date: today.subtract(const Duration(days: 3)),
        category: ExpenseCategory.line_fee,
        amount: 500.0,
        note: 'Route union registration sticker for 5 rickshaws',
        recordedBy: 'MGR-SELIM',
        isSynced: true,
        createdAt: today.subtract(const Duration(days: 3)),
      ),
    ];

    for (var e in expenses) {
      await hive.saveExpense(e);
    }

    // 5. Seed SMS Logs
    final smsLogs = [
      SmsLogModel(
        logId: 'SMS-INIT-01',
        driverId: 'D-102',
        driverName: 'Rafiqul Islam',
        driverPhone: '01812345678',
        message: 'শ্রদ্ধেয় Rafiqul Islam ভাই, প্রজেক্ট ৩ হুইল গ্যারেজে আপনার বকেয়া পাওনা ৳৭০০ টাকা। অনুগ্রহ করে দ্রুত পরিশোধ করুন। ধন্যবাদ।',
        timestamp: today.subtract(const Duration(hours: 2)),
        status: SmsStatus.sent,
        responseInfo: 'Greenweb SMS Gateway: 200 OK',
      ),
      SmsLogModel(
        logId: 'SMS-INIT-02',
        driverId: 'D-106',
        driverName: 'Billal Majhi',
        driverPhone: '01512223344',
        message: 'শ্রদ্ধেয় Billal Majhi ভাই, প্রজেক্ট ৩ হুইল গ্যারেজে আপনার বকেয়া পাওনা ৳১,৪০০ টাকা। অনুগ্রহ করে দ্রুত পরিশোধ করুন। ধন্যবাদ।',
        timestamp: today.subtract(const Duration(hours: 5)),
        status: SmsStatus.sent,
        responseInfo: 'Greenweb SMS Gateway: 200 OK',
      ),
    ];

    for (var s in smsLogs) {
      await hive.saveSmsLog(s);
    }

    debugPrint('[MockDataSeeder] Seeding finished successfully.');
  }
}
