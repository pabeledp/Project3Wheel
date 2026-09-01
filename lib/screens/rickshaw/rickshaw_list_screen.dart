import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/rickshaw_model.dart';
import '../../providers/fleet_provider.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/glass/glass_text_field.dart';
import '../../widgets/layout/responsive_layout_builder.dart';

class RickshawListScreen extends ConsumerStatefulWidget {
  const RickshawListScreen({super.key});

  @override
  ConsumerState<RickshawListScreen> createState() => _RickshawListScreenState();
}

class _RickshawListScreenState extends ConsumerState<RickshawListScreen> {
  final _idController = TextEditingController();
  final _rateController = TextEditingController(text: '350');
  final _modelController = TextEditingController(text: 'Mishuk Classic 48V');
  bool _isAdding = false;

  @override
  void dispose() {
    _idController.dispose();
    _rateController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  void _showAddRickshawDialog() {
    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: LiquidGlassContainer(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.electric_rickshaw, color: AppColors.primaryBlue, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Text('Add New Rickshaw', style: AppTypography.titleMedium),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(dialogCtx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  GlassTextField(
                    controller: _idController,
                    labelText: 'Rickshaw ID / Unit Number',
                    hintText: 'e.g. R-01',
                    prefixIcon: Icons.tag,
                  ),
                  const SizedBox(height: 14),
                  GlassTextField(
                    controller: _modelController,
                    labelText: 'Model & Specifications',
                    hintText: 'e.g. Mishuk Classic 48V / Runner 60V',
                    prefixIcon: Icons.electric_bolt_rounded,
                  ),
                  const SizedBox(height: 14),
                  GlassTextField(
                    controller: _rateController,
                    labelText: 'Standard Daily Joma Rate (৳)',
                    hintText: '350',
                    prefixIcon: Icons.currency_lira_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 22),
                  GlassButton(
                    text: 'Register Rickshaw',
                    icon: Icons.add_circle_outline,
                    variant: GlassButtonVariant.primary,
                    isLoading: _isAdding,
                    onPressed: () async {
                      final id = _idController.text.trim();
                      final rate = double.tryParse(_rateController.text) ?? 350.0;
                      final model = _modelController.text.trim();

                      if (id.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter Rickshaw ID'), backgroundColor: AppColors.crimsonRed),
                        );
                        return;
                      }

                      setDialogState(() => _isAdding = true);
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
                      setDialogState(() => _isAdding = false);
                      _idController.clear();
                      if (context.mounted) Navigator.pop(dialogCtx);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rickshaw $id added to fleet!'), backgroundColor: AppColors.emeraldGreen),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fleet = ref.watch(fleetProvider);
    final rickshaws = fleet.rickshaws;
    final drivers = fleet.drivers;

    return LiquidGlassBackgroundScaffold(
      appBar: AppBar(
        title: Text('Garage Rickshaw Fleet', style: AppTypography.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryBlue),
            tooltip: 'Add Rickshaw',
            onPressed: _showAddRickshawDialog,
          ),
        ],
      ),
      body: rickshaws.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.electric_rickshaw, size: 48, color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 16),
                  Text('No Rickshaws Registered', style: AppTypography.titleSmall),
                  const SizedBox(height: 6),
                  Text('Add your first electric rickshaw to start tracking', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 20),
                  GlassButton(
                    text: 'Add Rickshaw',
                    icon: Icons.add_rounded,
                    variant: GlassButtonVariant.primary,
                    onPressed: _showAddRickshawDialog,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              itemCount: rickshaws.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final r = rickshaws[index];
                final assignedDriver = drivers.where((d) => d.activeRickshawId == r.rickshawId || d.driverId == r.assignedDriverId).firstOrNull;

                return LiquidGlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.electric_rickshaw, color: Colors.white, size: 24),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  r.rickshawId,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: r.isActive ? AppColors.emeraldGreen.withOpacity(0.2) : AppColors.crimsonRed.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: r.isActive ? AppColors.emeraldGreen.withOpacity(0.5) : AppColors.crimsonRed.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text(
                                    r.isActive ? 'Active' : 'Maintenance',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: r.isActive ? AppColors.emeraldGreen : AppColors.crimsonRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              r.modelName ?? 'Electric Rickshaw',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 13, color: AppColors.electricAmber),
                                const SizedBox(width: 4),
                                Text(
                                  assignedDriver != null ? 'Pilot: ${assignedDriver.name}' : 'Pilot: Unassigned',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            CurrencyFormatter.formatBDT(r.dailyRentRate),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.emeraldGreenLight),
                          ),
                          const SizedBox(height: 2),
                          const Text('/day joma', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                          const SizedBox(height: 6),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.crimsonRedLight, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: AppColors.backgroundCard,
                                  title: const Text('Delete Rickshaw?', style: TextStyle(color: Colors.white)),
                                  content: Text('Are you sure you want to remove ${r.rickshawId} from the fleet?', style: const TextStyle(color: AppColors.textSecondary)),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: AppColors.crimsonRed))),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await ref.read(fleetProvider.notifier).deleteRickshaw(r.rickshawId);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
