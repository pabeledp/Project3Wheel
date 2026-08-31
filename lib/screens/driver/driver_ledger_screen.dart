import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/driver_model.dart';
import '../../providers/fleet_provider.dart';
import '../../services/sms/sms_gateway_service.dart';
import '../../services/sms/bangla_sms_templates.dart';
import '../../services/export/pdf_report_service.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_pill_badge.dart';
import '../../widgets/glass/glass_modal_bottom_sheet.dart';
import '../../widgets/layout/responsive_layout_builder.dart';
import 'driver_detail_modal.dart';

class DriverLedgerScreen extends ConsumerStatefulWidget {
  const DriverLedgerScreen({super.key});

  @override
  ConsumerState<DriverLedgerScreen> createState() => _DriverLedgerScreenState();
}

class _DriverLedgerScreenState extends ConsumerState<DriverLedgerScreen> {
  String _searchQuery = '';
  bool _onlyDefaulters = false;

  void _sendSmsReminder(DriverModel driver) async {
    final messagePreview = BanglaSmsTemplates.dueReminder(
      driverName: driver.name,
      dueAmount: driver.totalDue,
    );

    // Show Confirmation Dialog with Bengali Preview
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundElevated,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.sms_rounded, color: AppColors.primaryBlue),
              const SizedBox(width: 10),
              Text('Send Due Reminder SMS', style: AppTypography.titleSmall),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('To: ${driver.name} (${driver.phone})', style: AppTypography.labelMedium),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Text(
                  messagePreview,
                  style: AppTypography.banglaBody.copyWith(color: AppColors.electricAmberLight),
                ),
              ),
              const SizedBox(height: 12),
              Text('Gateway: Greenweb / BdSMS API', style: AppTypography.bodySmall.copyWith(fontSize: 10)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electricAmber,
                foregroundColor: Colors.black,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Send SMS Now', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final smsService = SmsGatewayService();
    final log = await smsService.sendDueReminder(
      driverId: driver.driverId,
      driverName: driver.name,
      driverPhone: driver.phone,
      dueAmount: driver.totalDue,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: log.isSuccess ? AppColors.emeraldGreen : AppColors.crimsonRed,
        content: Text(
          log.isSuccess
              ? 'Bengali SMS reminder sent to ${driver.name}!'
              : 'Failed to dispatch SMS: ${log.responseInfo}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fleetState = ref.watch(fleetProvider);

    final filtered = fleetState.drivers.where((d) {
      final matchesSearch = d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.phone.contains(_searchQuery) ||
          d.driverId.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDefaulter = !_onlyDefaulters || d.totalDue > 0;
      return matchesSearch && matchesDefaulter;
    }).toList()
      ..sort((a, b) => b.totalDue.compareTo(a.totalDue));

    return LiquidGlassBackgroundScaffold(
      appBar: AppBar(
        title: Text('Driver Roster & Ledger', style: AppTypography.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.electricAmber),
            tooltip: 'Export Defaulters PDF',
            onPressed: () async {
              final bytes = await PdfReportService.generateDefaultersPdf(
                drivers: fleetState.drivers,
                garageName: 'Project 3 Wheel - Mirpur Hub',
              );
              await PdfReportService.printReport(bytes, documentName: 'Defaulters_List');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Search and Defaulter Switch
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
                        hintText: 'Search driver name, phone, NID...',
                        hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 13),
                        icon: Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Toggle Defaulter Pill
                GestureDetector(
                  onTap: () => setState(() => _onlyDefaulters = !_onlyDefaulters),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: _onlyDefaulters ? AppColors.electricAmber.withOpacity(0.3) : AppColors.glassWhiteLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _onlyDefaulters ? AppColors.electricAmber : Colors.white.withOpacity(0.12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: _onlyDefaulters ? AppColors.electricAmber : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Defaulters',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _onlyDefaulters ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Header stats
            LiquidGlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.glassDarkLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Showing ${filtered.length} of ${fleetState.totalDrivers} Drivers', style: AppTypography.labelSmall),
                  Text(
                    'Outstanding: ${CurrencyFormatter.formatBDT(filtered.fold(0, (s, d) => s + d.totalDue))}',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.crimsonRedLight, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Driver List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.people_outline_rounded, size: 48, color: AppColors.textTertiary),
                          const SizedBox(height: 12),
                          Text('No matching drivers found', style: AppTypography.bodyMedium),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 90),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final driver = filtered[index];
                        return LiquidGlassContainer(
                          padding: const EdgeInsets.all(16),
                          onTap: () {
                            GlassModalBottomSheet.show(
                              context: context,
                              child: DriverDetailModal(driver: driver),
                            );
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: driver.hasDue
                                    ? AppColors.crimsonRed.withOpacity(0.25)
                                    : AppColors.primaryBlue.withOpacity(0.25),
                                child: Text(
                                  driver.name[0],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: driver.hasDue ? AppColors.crimsonRedLight : AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(driver.name, style: AppTypography.titleSmall),
                                        const SizedBox(width: 6),
                                        if (driver.activeRickshawId != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryBlue.withOpacity(0.18),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              driver.activeRickshawId!,
                                              style: const TextStyle(fontSize: 10, color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${driver.phone} • ${driver.address}',
                                      style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    CurrencyFormatter.formatBDT(driver.totalDue),
                                    style: AppTypography.financialAmount.copyWith(
                                      color: driver.hasDue ? AppColors.crimsonRedLight : AppColors.emeraldGreenLight,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (driver.hasDue)
                                    InkWell(
                                      onTap: () => _sendSmsReminder(driver),
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.electricAmber.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: AppColors.electricAmber.withOpacity(0.5)),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.sms_outlined, size: 12, color: AppColors.electricAmber),
                                            SizedBox(width: 4),
                                            Text(
                                              'Send SMS',
                                              style: TextStyle(fontSize: 10, color: AppColors.electricAmber, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    const GlassPillBadge(
                                      text: 'CLEAR',
                                      variant: GlassPillVariant.emerald,
                                      fontSize: 9,
                                    ),
                                ],
                              ),
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
