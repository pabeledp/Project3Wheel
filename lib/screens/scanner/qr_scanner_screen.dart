import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/rickshaw_model.dart';
import '../../models/driver_model.dart';
import '../../models/collection_model.dart';
import '../../providers/fleet_provider.dart';
import '../../providers/collection_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/glass/glass_pill_badge.dart';
import '../../widgets/glass/glass_modal_bottom_sheet.dart';
import '../collection/daily_collection_form_screen.dart';

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> with SingleTickerProviderStateMixin {
  late MobileScannerController _scannerController;
  late AnimationController _laserController;
  late Animation<double> _laserAnimation;
  bool _isProcessingScan = false;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );

    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _laserController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessingScan) return;
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final code = barcode.rawValue;
      if (code != null && code.isNotEmpty) {
        _handleScannedCode(code);
        break;
      }
    }
  }

  void _handleScannedCode(String scannedId) async {
    setState(() => _isProcessingScan = true);

    final fleetState = ref.read(fleetProvider);
    final cleanId = scannedId.trim().toUpperCase();

    // Match rickshaw
    final rickshaw = fleetState.rickshaws.cast<RickshawModel?>().firstWhere(
      (r) => r?.rickshawId.toUpperCase() == cleanId || r?.qrCode.toUpperCase() == cleanId,
      orElse: () => null,
    );

    if (!mounted) return;

    if (rickshaw != null) {
      final driver = fleetState.drivers.cast<DriverModel?>().firstWhere(
        (d) => d?.driverId == rickshaw.assignedDriverId,
        orElse: () => null,
      );

      final todayCollections = ref.read(collectionProvider).todayCollections;
      final todayRecord = todayCollections.cast<CollectionModel?>().firstWhere(
        (c) => c?.rickshawId == rickshaw.rickshawId,
        orElse: () => null,
      );

      _showScannedResultBottomSheet(rickshaw, driver, todayRecord);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.crimsonRed,
          content: Text('Unrecognized QR Code: "$cleanId". Not in fleet roster.'),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _isProcessingScan = false);
    }
  }

  void _showScannedResultBottomSheet(
    RickshawModel rickshaw,
    DriverModel? driver,
    CollectionModel? todayRecord,
  ) {
    GlassModalBottomSheet.show(
      context: context,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.electric_rickshaw, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rickshaw ${rickshaw.rickshawId}',
                          style: AppTypography.titleMedium,
                        ),
                        Text(
                          rickshaw.modelName ?? 'Mishuk Classic',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                GlassPillBadge.fromRickshawStatus(rickshaw.status),
              ],
            ),
            const SizedBox(height: 20),
            // Driver Information Card
            LiquidGlassContainer(
              padding: const EdgeInsets.all(16),
              color: AppColors.glassWhiteMedium,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.3),
                    child: Text(
                      driver != null ? driver.name[0] : '?',
                      style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver?.name ?? 'No Driver Assigned',
                          style: AppTypography.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          driver?.phone ?? 'Contact N/A',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'NID: ${driver?.nid ?? 'N/A'}',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  if (driver != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Cumulative Due', style: AppTypography.labelSmall),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.formatBDT(driver.totalDue),
                          style: AppTypography.financialAmount.copyWith(
                            color: driver.totalDue > 0 ? AppColors.crimsonRedLight : AppColors.emeraldGreenLight,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Today's Collection Status Card
            LiquidGlassContainer(
              padding: const EdgeInsets.all(16),
              color: AppColors.glassDarkLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Today's Collection Status", style: AppTypography.labelMedium),
                      const SizedBox(height: 4),
                      Text(
                        todayRecord != null
                            ? 'Paid: ${CurrencyFormatter.formatBDT(todayRecord.paidAmount)} / Due: ${CurrencyFormatter.formatBDT(todayRecord.dueAmount)}'
                            : 'Standard Rent Rate: ${CurrencyFormatter.formatBDT(rickshaw.dailyRentRate)}',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  if (todayRecord != null)
                    GlassPillBadge.fromPaymentStatus(todayRecord.paymentStatus)
                  else
                    const GlassPillBadge(
                      text: 'NOT RECORDED',
                      variant: GlassPillVariant.neutral,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: GlassButton(
                    text: todayRecord != null ? 'Edit Collection' : 'Record Deposit',
                    icon: Icons.add_card_rounded,
                    variant: GlassButtonVariant.emerald,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DailyCollectionFormScreen(
                            initialRickshawId: rickshaw.rickshawId,
                            initialDriverId: driver?.driverId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ).then((_) {
      if (mounted) setState(() => _isProcessingScan = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Camera View
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_outlined, color: AppColors.textSecondary, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Camera Simulation Mode',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Use quick test buttons below to simulate fleet QR scans.',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              );
            },
          ),
          // Dark Translucent Frosted Viewfinder Overlay
          Positioned.fill(
            child: Column(
              children: [
                // Top App Bar Controls
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LiquidGlassContainer(
                          padding: const EdgeInsets.all(8),
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        ),
                        Text(
                          'Scan Rickshaw QR',
                          style: AppTypography.titleMedium.copyWith(color: Colors.white),
                        ),
                        LiquidGlassContainer(
                          padding: const EdgeInsets.all(8),
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            setState(() => _torchOn = !_torchOn);
                            _scannerController.toggleTorch();
                          },
                          child: Icon(
                            _torchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                            color: _torchOn ? AppColors.electricAmber : Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // Glass Viewfinder Box
                Center(
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: Stack(
                      children: [
                        // Viewfinder Glass Corners
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                          ),
                        ),
                        // Corner Accent Brackets
                        ..._buildCornerAccents(),
                        // Animated Scanning Laser
                        AnimatedBuilder(
                          animation: _laserAnimation,
                          builder: (context, child) {
                            return Positioned(
                              top: 280 * _laserAnimation.value,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppColors.primaryBlue,
                                      AppColors.accentCyan,
                                      AppColors.primaryBlue,
                                      Colors.transparent,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryBlue.withOpacity(0.8),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Align QR Code within the liquid glass frame',
                  style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                ),
                const Spacer(),
                // Quick Simulated Scan Presets (For fast desktop/device testing)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: LiquidGlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Test Scan Simulator:',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['R-01', 'R-02', 'R-03', 'R-04', 'R-05', 'R-06'].map((id) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: () => _handleScannedCode(id),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBlue.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.primaryBlue.withOpacity(0.5)),
                                    ),
                                    child: Text(
                                      'Scan $id',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCornerAccents() {
    return [
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.primaryBlue, width: 4),
              left: BorderSide(color: AppColors.primaryBlue, width: 4),
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(28)),
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.primaryBlue, width: 4),
              right: BorderSide(color: AppColors.primaryBlue, width: 4),
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(28)),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.primaryBlue, width: 4),
              left: BorderSide(color: AppColors.primaryBlue, width: 4),
            ),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28)),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.primaryBlue, width: 4),
              right: BorderSide(color: AppColors.primaryBlue, width: 4),
            ),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(28)),
          ),
        ),
      ),
    ];
  }
}
