import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/rickshaw_model.dart';
import '../../providers/fleet_provider.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/glass/glass_text_field.dart';

class ManageRickshawsDialog extends ConsumerStatefulWidget {
  const ManageRickshawsDialog({super.key});

  @override
  ConsumerState<ManageRickshawsDialog> createState() => _ManageRickshawsDialogState();
}

class _ManageRickshawsDialogState extends ConsumerState<ManageRickshawsDialog> {
  final _idController = TextEditingController();
  final _rateController = TextEditingController(text: '350');
  final _modelController = TextEditingController(text: 'Mishuk Classic 60V Lithium');
  bool _isAdding = false;

  @override
  void dispose() {
    _idController.dispose();
    _rateController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  void _handleAddRickshaw() async {
    final id = _idController.text.trim();
    final rate = double.tryParse(_rateController.text) ?? 350.0;
    final model = _modelController.text.trim();

    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Rickshaw ID (e.g. R-04)'), backgroundColor: AppColors.crimsonRed),
      );
      return;
    }

    setState(() => _isAdding = true);
    final newR = RickshawModel(
      rickshawId: id,
      qrCode: id,
      status: RickshawStatus.active,
      deviceImei: '86420104829${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      dailyRentRate: rate,
      assignedDriverId: null,
      modelName: model.isNotEmpty ? model : 'Electric Rickshaw',
      lastLocation: LastLocation(lat: 23.8103, lng: 90.4125, speed: 0.0, updatedAt: DateTime.now()),
    );

    await ref.read(fleetProvider.notifier).addRickshaw(newR);
    setState(() => _isAdding = false);
    _idController.clear();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rickshaw $id added to fleet!'), backgroundColor: AppColors.emeraldGreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fleet = ref.watch(fleetProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: LiquidGlassContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          'assets/icons/rickshaw_white.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('Manage Rickshaws', style: AppTypography.titleMedium),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Add New Rickshaw Card
              LiquidGlassContainer(
                padding: const EdgeInsets.all(14),
                color: AppColors.glassWhiteLight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Add New Vehicle to Fleet', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GlassTextField(
                            controller: _idController,
                            labelText: 'Vehicle ID',
                            hintText: 'e.g. R-04',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GlassTextField(
                            controller: _rateController,
                            labelText: 'Rate (৳/day)',
                            hintText: '350',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GlassTextField(
                      controller: _modelController,
                      labelText: 'Model & Specs',
                      hintText: 'e.g. Mishuk 60V Lithium',
                    ),
                    const SizedBox(height: 12),
                    GlassButton(
                      text: 'Add to Fleet',
                      icon: Icons.add_circle_outline,
                      variant: GlassButtonVariant.primary,
                      isLoading: _isAdding,
                      onPressed: _handleAddRickshaw,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Existing Vehicles List
              Text('Registered Fleet Units (${fleet.rickshaws.length})', style: AppTypography.labelMedium),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: fleet.rickshaws.isEmpty
                    ? const Center(child: Text('No vehicles registered', style: TextStyle(color: AppColors.textTertiary)))
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: fleet.rickshaws.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          final r = fleet.rickshaws[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white.withOpacity(0.08)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryBlue.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(r.rickshawId, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 12)),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(r.modelName ?? 'Electric Rickshaw', style: const TextStyle(fontSize: 12, color: Colors.white)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(CurrencyFormatter.formatBDT(r.dailyRentRate), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.emeraldGreenLight)),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.crimsonRedLight, size: 18),
                                      onPressed: () async {
                                        await ref.read(fleetProvider.notifier).deleteRickshaw(r.rickshawId);
                                      },
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
      ),
    );
  }
}
