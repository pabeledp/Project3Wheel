import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
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
import '../../widgets/glass/glass_text_field.dart';
import '../../widgets/glass/glass_pill_badge.dart';
import '../../widgets/layout/responsive_layout_builder.dart';

class DailyCollectionFormScreen extends ConsumerStatefulWidget {
  final String? initialRickshawId;
  final String? initialDriverId;

  const DailyCollectionFormScreen({
    super.key,
    this.initialRickshawId,
    this.initialDriverId,
  });

  @override
  ConsumerState<DailyCollectionFormScreen> createState() => _DailyCollectionFormScreenState();
}

class _DailyCollectionFormScreenState extends ConsumerState<DailyCollectionFormScreen> {
  final _paidAmountController = TextEditingController(text: '350');
  final _expectedAmountController = TextEditingController(text: '350');
  String? _selectedRickshawId;
  String? _selectedDriverId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRickshawId = widget.initialRickshawId ?? 'R-01';
    _selectedDriverId = widget.initialDriverId;
  }

  @override
  void dispose() {
    _paidAmountController.dispose();
    _expectedAmountController.dispose();
    super.dispose();
  }

  void _onRickshawChanged(String? newId) {
    setState(() {
      _selectedRickshawId = newId;
      final fleet = ref.read(fleetProvider);
      final r = fleet.rickshaws.cast<RickshawModel?>().firstWhere(
        (elem) => elem?.rickshawId == newId,
        orElse: () => null,
      );
      if (r != null) {
        _selectedDriverId = r.assignedDriverId;
        _expectedAmountController.text = r.dailyRentRate.toStringAsFixed(0);
        _paidAmountController.text = r.dailyRentRate.toStringAsFixed(0);
      }
    });
  }

  double get _expected => double.tryParse(_expectedAmountController.text) ?? 350.0;
  double get _paid => double.tryParse(_paidAmountController.text) ?? 0.0;
  double get _due => (_expected - _paid).clamp(0.0, double.infinity);

  PaymentStatus get _status {
    if (_due <= 0) return PaymentStatus.paid;
    if (_paid > 0) return PaymentStatus.due;
    return PaymentStatus.unpaid;
  }

  void _submit() async {
    if (_selectedRickshawId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rickshaw')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final fleet = ref.read(fleetProvider);
    final driver = fleet.drivers.cast<DriverModel?>().firstWhere(
      (d) => d?.driverId == _selectedDriverId,
      orElse: () => null,
    );

    final currentUser = ref.read(authProvider).currentUser;

    await ref.read(collectionProvider.notifier).recordCollection(
      rickshawId: _selectedRickshawId!,
      driverId: _selectedDriverId ?? 'UNKNOWN',
      driverName: driver?.name ?? 'Assigned Driver',
      expectedAmount: _expected,
      paidAmount: _paid,
      recordedBy: currentUser.uid,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.emeraldGreen,
        content: Text('Deposit of ${CurrencyFormatter.formatBDT(_paid)} recorded successfully!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final fleetState = ref.watch(fleetProvider);
    final selectedDriver = fleetState.drivers.cast<DriverModel?>().firstWhere(
      (d) => d?.driverId == _selectedDriverId,
      orElse: () => null,
    );

    return LiquidGlassBackgroundScaffold(
      appBar: AppBar(
        title: Text('Record Daily Deposit', style: AppTypography.titleMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Real-time Status Card
                LiquidGlassContainer(
                  padding: const EdgeInsets.all(20),
                  color: AppColors.glassWhiteMedium,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Calculated Status', style: AppTypography.labelMedium),
                          GlassPillBadge.fromPaymentStatus(_status),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildCalculationColumn('Expected Rate', CurrencyFormatter.formatBDT(_expected), AppColors.textPrimary),
                          _buildCalculationColumn('Paid Amount', CurrencyFormatter.formatBDT(_paid), AppColors.emeraldGreenLight),
                          _buildCalculationColumn('Remaining Due', CurrencyFormatter.formatBDT(_due), _due > 0 ? AppColors.crimsonRedLight : AppColors.textSecondary),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Form Inputs Container
                LiquidGlassContainer(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rickshaw Dropdown
                      Text('Assigned Rickshaw', style: AppTypography.labelMedium),
                      const SizedBox(height: 8),
                      LiquidGlassContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        color: AppColors.glassWhiteLight,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedRickshawId,
                            isExpanded: true,
                            dropdownColor: AppColors.backgroundElevated,
                            style: AppTypography.bodyLarge,
                            items: fleetState.rickshaws.map((r) {
                              return DropdownMenuItem<String>(
                                value: r.rickshawId,
                                child: Text('${r.rickshawId} - ${r.modelName} (${CurrencyFormatter.formatBDT(r.dailyRentRate)}/day)'),
                              );
                            }).toList(),
                            onChanged: _onRickshawChanged,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Driver Info
                      if (selectedDriver != null) ...[
                        LiquidGlassContainer(
                          padding: const EdgeInsets.all(12),
                          color: AppColors.glassDarkLight,
                          child: Row(
                            children: [
                              const Icon(Icons.person_pin_rounded, color: AppColors.primaryBlue, size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(selectedDriver.name, style: AppTypography.titleSmall),
                                    Text('Phone: ${selectedDriver.phone} • Cumulative Due: ${CurrencyFormatter.formatBDT(selectedDriver.totalDue)}',
                                        style: AppTypography.bodySmall),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      // Expected Rate
                      GlassTextField(
                        controller: _expectedAmountController,
                        labelText: 'Standard Daily Rent Rate (৳)',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.payments_outlined,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),
                      // Paid Amount
                      GlassTextField(
                        controller: _paidAmountController,
                        labelText: 'Amount Deposited Today (৳)',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.account_balance_wallet_outlined,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      // Quick Preset Chips
                      Text('Quick Amount Presets', style: AppTypography.labelSmall),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildPresetChip('Full (৳350)', 350),
                          const SizedBox(width: 8),
                          _buildPresetChip('Partial (৳200)', 200),
                          const SizedBox(width: 8),
                          _buildPresetChip('Zero (৳0)', 0),
                        ],
                      ),
                      const SizedBox(height: 28),
                      GlassButton(
                        text: 'Confirm & Save Collection',
                        icon: Icons.check_circle_outline_rounded,
                        variant: GlassButtonVariant.emerald,
                        isLoading: _isLoading,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalculationColumn(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.financialAmount.copyWith(
            color: valueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPresetChip(String label, double amount) {
    return InkWell(
      onTap: () {
        setState(() {
          _paidAmountController.text = amount.toStringAsFixed(0);
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
