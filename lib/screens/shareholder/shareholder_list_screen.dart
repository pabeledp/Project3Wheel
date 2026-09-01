import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/shareholder_model.dart';
import '../../providers/report_provider.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/glass/glass_text_field.dart';
import '../../widgets/layout/responsive_layout_builder.dart';

// Simple Shareholder State Notifier for Flutter
class ShareholderState {
  final List<ShareholderModel> shareholders;
  const ShareholderState({this.shareholders = const []});
}

class ShareholderNotifier extends StateNotifier<ShareholderState> {
  ShareholderNotifier() : super(const ShareholderState());

  void addShareholder(ShareholderModel sh) {
    state = ShareholderState(shareholders: [...state.shareholders, sh]);
  }

  void removeShareholder(String id) {
    state = ShareholderState(shareholders: state.shareholders.where((s) => s.id != id).toList());
  }
}

final shareholderProvider = StateNotifierProvider<ShareholderNotifier, ShareholderState>((ref) {
  return ShareholderNotifier();
});

class ShareholderListScreen extends ConsumerStatefulWidget {
  const ShareholderListScreen({super.key});

  @override
  ConsumerState<ShareholderListScreen> createState() => _ShareholderListScreenState();
}

class _ShareholderListScreenState extends ConsumerState<ShareholderListScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _equityController = TextEditingController(text: '20');
  final _investmentController = TextEditingController(text: '300000');
  final _rickshawsController = TextEditingController(text: 'R-01');

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _equityController.dispose();
    _investmentController.dispose();
    _rickshawsController.dispose();
    super.dispose();
  }

  void _showAddShareholderDialog() {
    showDialog(
      context: context,
      builder: (dialogCtx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: LiquidGlassContainer(
            padding: const EdgeInsets.all(22),
            child: SingleChildScrollView(
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
                              color: AppColors.primaryPurple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.handshake_rounded, color: AppColors.primaryPurple, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Text('Add Shareholder', style: AppTypography.titleMedium),
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
                    controller: _nameController,
                    labelText: 'Partner / Shareholder Name',
                    hintText: 'Enter partner full name',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 14),
                  GlassTextField(
                    controller: _phoneController,
                    labelText: 'Mobile Number',
                    hintText: '017xxxxxxxx',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: GlassTextField(
                          controller: _equityController,
                          labelText: 'Equity Share (%)',
                          hintText: '25',
                          prefixIcon: Icons.pie_chart_outline,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GlassTextField(
                          controller: _investmentController,
                          labelText: 'Investment (৳)',
                          hintText: '500000',
                          prefixIcon: Icons.payments_outlined,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GlassTextField(
                    controller: _rickshawsController,
                    labelText: 'Assigned Rickshaws',
                    hintText: 'e.g. R-01, R-02',
                    prefixIcon: Icons.electric_rickshaw,
                  ),
                  const SizedBox(height: 22),
                  GlassButton(
                    text: 'Register Partner',
                    icon: Icons.person_add_rounded,
                    variant: GlassButtonVariant.primary,
                    onPressed: () {
                      final name = _nameController.text.trim();
                      final phone = _phoneController.text.trim();
                      final eq = double.tryParse(_equityController.text) ?? 0.0;
                      final inv = double.tryParse(_investmentController.text) ?? 0.0;
                      final rUnits = _rickshawsController.text.trim();

                      if (name.isEmpty || phone.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter name and phone number'), backgroundColor: AppColors.crimsonRed),
                        );
                        return;
                      }

                      final newSh = ShareholderModel(
                        id: 'SH-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                        name: name,
                        phone: phone,
                        equity: eq,
                        investment: inv,
                        rickshaws: rUnits,
                        joinDate: DateTime.now().toIso8601String().split('T')[0],
                      );

                      ref.read(shareholderProvider.notifier).addShareholder(newSh);
                      _nameController.clear();
                      _phoneController.clear();
                      Navigator.pop(dialogCtx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Shareholder $name added!'), backgroundColor: AppColors.emeraldGreen),
                      );
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
    final shareholderState = ref.watch(shareholderProvider);
    final summary = ref.watch(financialSummaryProvider);
    final netProfit = (summary.todayRevenue - summary.todayExpense).clamp(0.0, double.infinity);
    final list = shareholderState.shareholders;

    return LiquidGlassBackgroundScaffold(
      appBar: AppBar(
        title: Text('Shareholders & Equity', style: AppTypography.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded, color: AppColors.primaryPurple),
            tooltip: 'Add Shareholder',
            onPressed: _showAddShareholderDialog,
          ),
        ],
      ),
      body: list.isEmpty
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
                    child: const Icon(Icons.handshake_rounded, size: 48, color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 16),
                  Text('No Shareholders Registered', style: AppTypography.titleSmall),
                  const SizedBox(height: 6),
                  Text('Add equity partners and garage investors', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: 20),
                  GlassButton(
                    text: 'Add Partner',
                    icon: Icons.person_add_rounded,
                    variant: GlassButtonVariant.primary,
                    onPressed: _showAddShareholderDialog,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final sh = list[index];
                final dividend = (netProfit * (sh.equity / 100)).round();

                return LiquidGlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.primaryPurple.withOpacity(0.3),
                                child: Text(sh.name.isNotEmpty ? sh.name[0] : 'S', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(sh.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                                  Text(sh.phone, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${sh.equity}% Equity',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Investment', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                                const SizedBox(height: 2),
                                Text(CurrencyFormatter.formatBDT(sh.investment), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Estimated P&L', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                                const SizedBox(height: 2),
                                Text(CurrencyFormatter.formatBDT(dividend.toDouble()), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.emeraldGreenLight)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Units', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                                const SizedBox(height: 2),
                                Text(sh.rickshaws.isNotEmpty ? sh.rickshaws : 'None', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.electricAmber)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.crimsonRedLight, size: 20),
                          onPressed: () {
                            ref.read(shareholderProvider.notifier).removeShareholder(sh.id);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
