import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/collection_model.dart';
import '../../models/expense_model.dart';
import '../../models/driver_model.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_utils.dart';

class PdfReportService {
  PdfReportService._();

  /// 1-Click Daily Collection Summary PDF Generation
  static Future<Uint8List> generateDailyCollectionPdf({
    required DateTime date,
    required List<CollectionModel> collections,
    required String garageName,
    required String preparedBy,
  }) async {
    final pdf = pw.Document();

    final totalExpected = collections.fold<double>(0, (sum, item) => sum + item.expectedAmount);
    final totalCollected = collections.fold<double>(0, (sum, item) => sum + item.paidAmount);
    final totalDue = collections.fold<double>(0, (sum, item) => sum + item.dueAmount);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildPdfHeader(
            title: 'Daily Fleet Collection Summary',
            subtitle: 'Report Date: ${AppDateUtils.formatDate(date)}',
            garageName: garageName,
          ),
          pw.SizedBox(height: 20),
          _buildMetricsRow([
            _MetricItem('Target Revenue', CurrencyFormatter.formatBDT(totalExpected)),
            _MetricItem('Total Collected', CurrencyFormatter.formatBDT(totalCollected), color: PdfColors.green700),
            _MetricItem('Outstanding Due', CurrencyFormatter.formatBDT(totalDue), color: PdfColors.orange700),
          ]),
          pw.SizedBox(height: 24),
          pw.Text('Detailed Fleet Roster & Deposited Dues', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: ['Rickshaw', 'Driver Name', 'Target', 'Paid', 'Due', 'Status', 'Time'],
            headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF141923)),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellAlignment: pw.Alignment.centerLeft,
            data: collections.map((c) => [
              c.rickshawId,
              c.driverName,
              CurrencyFormatter.formatBDT(c.expectedAmount),
              CurrencyFormatter.formatBDT(c.paidAmount),
              CurrencyFormatter.formatBDT(c.dueAmount),
              c.paymentStatus.name.toUpperCase(),
              AppDateUtils.formatTime(c.createdAt),
            ]).toList(),
          ),
          pw.SizedBox(height: 32),
          _buildPdfSignatures(preparedBy: preparedBy),
        ],
      ),
    );

    return pdf.save();
  }

  /// 1-Click Monthly Profit & Loss (P&L) PDF Generation
  static Future<Uint8List> generateMonthlyPnlPdf({
    required DateTime month,
    required List<CollectionModel> collections,
    required List<ExpenseModel> expenses,
    required String garageName,
  }) async {
    final pdf = pw.Document();

    final totalRevenue = collections.fold<double>(0, (sum, item) => sum + item.paidAmount);
    final totalExpenses = expenses.fold<double>(0, (sum, item) => sum + item.amount);
    final netCashFlow = totalRevenue - totalExpenses;

    // Group expenses by category
    final expenseBreakdown = <ExpenseCategory, double>{};
    for (var exp in expenses) {
      expenseBreakdown[exp.category] = (expenseBreakdown[exp.category] ?? 0) + exp.amount;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildPdfHeader(
            title: 'Monthly Financial Statement (P&L)',
            subtitle: 'Accounting Period: ${AppDateUtils.formatMonthYear(month)}',
            garageName: garageName,
          ),
          pw.SizedBox(height: 20),
          _buildMetricsRow([
            _MetricItem('Gross Collections', CurrencyFormatter.formatBDT(totalRevenue), color: PdfColors.green700),
            _MetricItem('Total Expenses', CurrencyFormatter.formatBDT(totalExpenses), color: PdfColors.red700),
            _MetricItem(
              'Net Profit / Cash Flow',
              CurrencyFormatter.formatBDT(netCashFlow),
              color: netCashFlow >= 0 ? PdfColors.green800 : PdfColors.red800,
            ),
          ]),
          pw.SizedBox(height: 24),
          pw.Text('Expense Categorical Breakdown', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['Category', 'Expense Type Description', 'Total Incurred', '% of Total'],
            headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF141923)),
            cellStyle: const pw.TextStyle(fontSize: 9),
            data: expenseBreakdown.entries.map((entry) {
              final pct = totalExpenses > 0 ? (entry.value / totalExpenses * 100).toStringAsFixed(1) : '0.0';
              return [
                entry.key.name.toUpperCase(),
                _getCategoryLabel(entry.key),
                CurrencyFormatter.formatBDT(entry.value),
                '$pct%',
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 32),
          _buildPdfSignatures(preparedBy: 'Fleet Accounting Engine'),
        ],
      ),
    );

    return pdf.save();
  }

  /// 1-Click Defaulter List PDF Generation
  static Future<Uint8List> generateDefaultersPdf({
    required List<DriverModel> drivers,
    required String garageName,
  }) async {
    final pdf = pw.Document();
    final defaulters = drivers.where((d) => d.totalDue > 0).toList();
    defaulters.sort((a, b) => b.totalDue.compareTo(a.totalDue));

    final totalDues = defaulters.fold<double>(0, (sum, d) => sum + d.totalDue);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildPdfHeader(
            title: 'Defaulters & Pending Due Ledger',
            subtitle: 'Generated on: ${AppDateUtils.formatDateTime(DateTime.now())}',
            garageName: garageName,
          ),
          pw.SizedBox(height: 20),
          _buildMetricsRow([
            _MetricItem('Total Defaulters', '${defaulters.length} Drivers', color: PdfColors.orange800),
            _MetricItem('Cumulative Receivables', CurrencyFormatter.formatBDT(totalDues), color: PdfColors.red800),
          ]),
          pw.SizedBox(height: 24),
          pw.TableHelper.fromTextArray(
            headers: ['Driver ID', 'Driver Name', 'Contact Phone', 'National ID (NID)', 'Assigned Rickshaw', 'Cumulative Due'],
            headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF141923)),
            cellStyle: const pw.TextStyle(fontSize: 9),
            data: defaulters.map((d) => [
              d.driverId,
              d.name,
              d.phone,
              d.nid,
              d.activeRickshawId ?? 'None',
              CurrencyFormatter.formatBDT(d.totalDue),
            ]).toList(),
          ),
          pw.SizedBox(height: 32),
          _buildPdfSignatures(preparedBy: 'Audit & Collection Manager'),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildPdfHeader({
    required String title,
    required String subtitle,
    required String garageName,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('PROJECT 3 WHEEL', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF0A84FF))),
            pw.SizedBox(height: 4),
            pw.Text(title, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 2),
            pw.Text(subtitle, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(garageName, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Text('Fleet & Financial Management Hub', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
            pw.Text('Dhaka, Bangladesh', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildMetricsRow(List<_MetricItem> items) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: items.map((item) {
        return pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
            color: PdfColors.grey100,
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(item.title, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
              pw.SizedBox(height: 4),
              pw.Text(item.value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: item.color ?? PdfColors.black)),
            ],
          ),
        );
      }).toList(),
    );
  }

  static pw.Widget _buildPdfSignatures({required String preparedBy}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(width: 140, height: 1, color: PdfColors.black),
            pw.SizedBox(height: 4),
            pw.Text('Prepared By: $preparedBy', style: const pw.TextStyle(fontSize: 8)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Container(width: 140, height: 1, color: PdfColors.black),
            pw.SizedBox(height: 4),
            pw.Text('Garage Owner / Director Signature', style: const pw.TextStyle(fontSize: 8)),
          ],
        ),
      ],
    );
  }

  static String _getCategoryLabel(ExpenseCategory cat) {
    switch (cat) {
      case ExpenseCategory.mechanic: return 'Mechanic & Servicing';
      case ExpenseCategory.parts: return 'Spare Parts & Batteries';
      case ExpenseCategory.rent: return 'Garage Rent & Electricity';
      case ExpenseCategory.line_fee: return 'Union / Route Fee';
      case ExpenseCategory.other: return 'Miscellaneous';
    }
  }

  /// Direct print or preview trigger
  static Future<void> printReport(Uint8List pdfBytes, {String documentName = 'Project_3_Wheel_Report'}) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: documentName,
    );
  }
}

class _MetricItem {
  final String title;
  final String value;
  final PdfColor? color;
  _MetricItem(this.title, this.value, {this.color});
}
