import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/expense_model.dart';
import '../../providers/expense_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/glass/glass_text_field.dart';
import '../../widgets/layout/responsive_layout_builder.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.parts;
  String _spender = 'Habib Rahman (Owner)';
  bool _isLoading = false;
  String? _attachedReceiptName;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid expense amount')),
      );
      return;
    }

    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a short description/note')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final currentUser = ref.read(authProvider).currentUser;

    await ref.read(expenseProvider.notifier).recordExpense(
      category: _selectedCategory,
      amount: amount,
      note: _noteController.text.trim(),
      recordedBy: currentUser.name,
      receiptImageUrl: _attachedReceiptName != null ? 'https://storage.googleapis.com/demo/receipt.jpg' : null,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.crimsonRed,
        content: Text('Expense of ${CurrencyFormatter.formatBDT(amount)} recorded successfully!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).currentUser;
    return LiquidGlassBackgroundScaffold(
      appBar: AppBar(
        title: Text('Record Garage Expense', style: AppTypography.titleMedium),
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
                LiquidGlassContainer(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Expense Category', style: AppTypography.labelMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ExpenseCategory.values.map((cat) {
                          final isSelected = _selectedCategory == cat;
                          return InkWell(
                            onTap: () => setState(() => _selectedCategory = cat),
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.crimsonRed.withOpacity(0.25)
                                    : Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.crimsonRedLight
                                      : Colors.white.withOpacity(0.12),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getCategoryIcon(cat),
                                    size: 16,
                                    color: isSelected ? AppColors.crimsonRedLight : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _getCategoryName(cat),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? Colors.white : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      GlassTextField(
                        controller: _amountController,
                        labelText: 'Expense Amount (৳)',
                        hintText: 'e.g. 1250',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.payments_rounded,
                      ),
                      const SizedBox(height: 16),
                      // Paid By Spender Selector
                      Text('Paid By (Spender)', style: AppTypography.labelMedium),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundElevated,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.15)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _spender,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF141A26),
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryBlue),
                            items: [
                              DropdownMenuItem(value: '${user.name.isNotEmpty ? user.name : 'Owner'} (${user.roleDisplayName})', child: Text('${user.name.isNotEmpty ? user.name : 'Owner'} (${user.roleDisplayName})')),
                              const DropdownMenuItem(value: 'Garage Petty Cash', child: Text('Garage Petty Cash')),
                              const DropdownMenuItem(value: 'Fleet Fund', child: Text('Fleet Fund')),
                              const DropdownMenuItem(value: 'Emergency Buffer', child: Text('Emergency Buffer')),
                            ],
                            onChanged: (val) => setState(() => _spender = val ?? (user.name.isNotEmpty ? user.name : 'Owner')),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GlassTextField(
                        controller: _noteController,
                        labelText: 'Description / Purpose / Vendor',
                        hintText: 'e.g. 2x Front Brake Pads & 48V Relay repair',
                        maxLines: 2,
                        prefixIcon: Icons.edit_note_rounded,
                      ),
                      const SizedBox(height: 20),
                      // Receipt Attachment Box
                      Text('Receipt Image / Invoice (Optional)', style: AppTypography.labelMedium),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _attachedReceiptName = 'voucher_${DateTime.now().millisecondsSinceEpoch}.jpg';
                          });
                        },
                        borderRadius: AppDimensions.borderRadiusMedium,
                        child: LiquidGlassContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          color: AppColors.glassWhiteLight,
                          child: Row(
                            children: [
                              Icon(
                                _attachedReceiptName != null ? Icons.check_circle_rounded : Icons.add_a_photo_outlined,
                                color: _attachedReceiptName != null ? AppColors.emeraldGreen : AppColors.primaryBlue,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _attachedReceiptName ?? 'Tap to attach receipt photo / bill',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: _attachedReceiptName != null ? Colors.white : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              if (_attachedReceiptName != null)
                                IconButton(
                                  icon: const Icon(Icons.close, size: 16, color: AppColors.crimsonRed),
                                  onPressed: () => setState(() => _attachedReceiptName = null),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      GlassButton(
                        text: 'Save Expense Entry',
                        icon: Icons.save_alt_rounded,
                        variant: GlassButtonVariant.crimson,
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

  IconData _getCategoryIcon(ExpenseCategory cat) {
    switch (cat) {
      case ExpenseCategory.mechanic: return Icons.build_rounded;
      case ExpenseCategory.parts: return Icons.settings_rounded;
      case ExpenseCategory.rent: return Icons.electric_bolt_rounded;
      case ExpenseCategory.line_fee: return Icons.badge_rounded;
      case ExpenseCategory.other: return Icons.more_horiz_rounded;
    }
  }

  String _getCategoryName(ExpenseCategory cat) {
    switch (cat) {
      case ExpenseCategory.mechanic: return 'Mechanic';
      case ExpenseCategory.parts: return 'Parts & Battery';
      case ExpenseCategory.rent: return 'Rent & Power';
      case ExpenseCategory.line_fee: return 'Line Fee';
      case ExpenseCategory.other: return 'Other';
    }
  }
}
