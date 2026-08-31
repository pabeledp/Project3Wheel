import 'dart:typed_data';
import 'package:excel/excel.dart';
import '../../models/collection_model.dart';
import '../../models/expense_model.dart';
import '../../models/driver_model.dart';
import '../../core/utils/date_utils.dart';

class ExcelReportService {
  ExcelReportService._();

  /// 1-Click Excel Workbook Generation with Collections, Expenses, and Defaulters
  static Uint8List generateFullAuditExcel({
    required List<CollectionModel> collections,
    required List<ExpenseModel> expenses,
    required List<DriverModel> drivers,
  }) {
    final excel = Excel.createExcel();

    // 1. Daily Collections Sheet
    final Sheet collectionSheet = excel['Daily Collections'];
    excel.setDefaultSheet('Daily Collections');

    collectionSheet.appendRow([
      TextCellValue('Date'),
      TextCellValue('Rickshaw ID'),
      TextCellValue('Driver ID'),
      TextCellValue('Driver Name'),
      TextCellValue('Expected (BDT)'),
      TextCellValue('Paid (BDT)'),
      TextCellValue('Due (BDT)'),
      TextCellValue('Payment Status'),
      TextCellValue('Recorded By'),
    ]);

    for (var c in collections) {
      collectionSheet.appendRow([
        TextCellValue(AppDateUtils.formatDate(c.date)),
        TextCellValue(c.rickshawId),
        TextCellValue(c.driverId),
        TextCellValue(c.driverName),
        DoubleCellValue(c.expectedAmount),
        DoubleCellValue(c.paidAmount),
        DoubleCellValue(c.dueAmount),
        TextCellValue(c.paymentStatus.name.toUpperCase()),
        TextCellValue(c.recordedBy),
      ]);
    }

    // 2. Expenses Sheet
    final Sheet expenseSheet = excel['Expenses'];
    expenseSheet.appendRow([
      TextCellValue('Date'),
      TextCellValue('Category'),
      TextCellValue('Amount (BDT)'),
      TextCellValue('Note / Description'),
      TextCellValue('Recorded By'),
    ]);

    for (var e in expenses) {
      expenseSheet.appendRow([
        TextCellValue(AppDateUtils.formatDate(e.date)),
        TextCellValue(e.category.name.toUpperCase()),
        DoubleCellValue(e.amount),
        TextCellValue(e.note),
        TextCellValue(e.recordedBy),
      ]);
    }

    // 3. Drivers Ledger & Defaulters Sheet
    final Sheet driverSheet = excel['Drivers & Dues'];
    driverSheet.appendRow([
      TextCellValue('Driver ID'),
      TextCellValue('Full Name'),
      TextCellValue('Phone Number'),
      TextCellValue('National ID (NID)'),
      TextCellValue('Active Rickshaw'),
      TextCellValue('Total Due (BDT)'),
      TextCellValue('Joined Date'),
    ]);

    for (var d in drivers) {
      driverSheet.appendRow([
        TextCellValue(d.driverId),
        TextCellValue(d.name),
        TextCellValue(d.phone),
        TextCellValue(d.nid),
        TextCellValue(d.activeRickshawId ?? 'N/A'),
        DoubleCellValue(d.totalDue),
        TextCellValue(AppDateUtils.formatDate(d.joinedDate)),
      ]);
    }

    final fileBytes = excel.save();
    return Uint8List.fromList(fileBytes ?? []);
  }
}
