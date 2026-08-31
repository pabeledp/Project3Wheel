import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_utils.dart';
import '../../models/collection_model.dart';
import '../../providers/collection_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/export/pdf_report_service.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_pill_badge.dart';
import '../../widgets/layout/responsive_layout_builder.dart';
import 'daily_collection_form_screen.dart';

class CollectionLedgerScreen extends ConsumerStatefulWidget {
  const CollectionLedgerScreen({super.key});

  @override
  ConsumerState<CollectionLedgerScreen> createState() => _CollectionLedgerScreenState();
}

class _CollectionLedgerScreenState extends ConsumerState<CollectionLedgerScreen> {
  String _searchQuery = '';
  PaymentStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final collectionState = ref.watch(collectionProvider);
    final currentUser = ref.watch(authProvider).currentUser;

    var filtered = collectionState.collections.where((c) {
      final matchesSearch = c.driverName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.rickshawId.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _filterStatus == null || c.paymentStatus == _filterStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return LiquidGlassBackgroundScaffold(
      appBar: AppBar(
        title: Text('Collections Ledger', style: AppTypography.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primaryBlue),
            tooltip: 'Export Daily Summary PDF',
            onPressed: () async {
              final bytes = await PdfReportService.generateDailyCollectionPdf(
                date: DateTime.now(),
                collections: collectionState.todayCollections,
                garageName: 'Project 3 Wheel - Mirpur Hub',
                preparedBy: currentUser.name,
              );
              await PdfReportService.printReport(bytes, documentName: 'Daily_Collections_Summary');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.emeraldGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Deposit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DailyCollectionFormScreen()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Search and Status Filters
            Row(
              children: [
                Expanded(
                  child: LiquidGlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    borderRadius: AppDimensions.borderRadiusMedium,
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search rickshaw or driver...',
                        hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 13),
                        icon: Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Filter status menu
                PopupMenuButton<PaymentStatus?>(
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.glassWhiteMedium,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.filter_list_rounded, color: Colors.white, size: 20),
                  ),
                  color: AppColors.backgroundElevated,
                  onSelected: (status) => setState(() => _filterStatus = status),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: null, child: Text('All Statuses')),
                    const PopupMenuItem(value: PaymentStatus.paid, child: Text('Full Paid')),
                    const PopupMenuItem(value: PaymentStatus.due, child: Text('Partial Due')),
                    const PopupMenuItem(value: PaymentStatus.unpaid, child: Text('Unpaid')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Today's summary mini banner
            LiquidGlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.glassDarkLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Filtered: ${filtered.length} entries', style: AppTypography.labelSmall),
                  Text(
                    'Collected: ${CurrencyFormatter.formatBDT(filtered.fold(0, (s, c) => s + c.paidAmount))}',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.emeraldGreenLight, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // List of Collections
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textTertiary),
                          const SizedBox(height: 12),
                          Text('No collection entries found', style: AppTypography.bodyMedium),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 90),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final c = filtered[index];
                        return LiquidGlassContainer(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: c.isFullPaid
                                      ? AppColors.emeraldGradient
                                      : (c.hasPartialDue ? AppColors.amberGradient : AppColors.crimsonGradient),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    c.rickshawId,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c.driverName, style: AppTypography.titleSmall),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${AppDateUtils.formatDate(c.date)} • Recorded by ${c.recordedBy}',
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    CurrencyFormatter.formatBDT(c.paidAmount),
                                    style: AppTypography.financialAmount.copyWith(
                                      color: c.isFullPaid ? AppColors.emeraldGreenLight : AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  GlassPillBadge.fromPaymentStatus(c.paymentStatus),
                                ],
                              ),
                              if (currentUser.isOwner) ...[
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.crimsonRed, size: 18),
                                  onPressed: () {
                                    ref.read(collectionProvider.notifier).deleteCollection(c.id);
                                  },
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
