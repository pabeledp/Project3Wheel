import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../models/driver_model.dart';
import '../../providers/fleet_provider.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/glass/glass_text_field.dart';

class AddDriverDialog extends ConsumerStatefulWidget {
  const AddDriverDialog({super.key});

  @override
  ConsumerState<AddDriverDialog> createState() => _AddDriverDialogState();
}

class _AddDriverDialogState extends ConsumerState<AddDriverDialog> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nidController = TextEditingController();
  final _rateController = TextEditingController(text: '350');
  final _addressController = TextEditingController(text: 'Mirpur, Dhaka');
  String? _assignedRickshawId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _idController.text = 'D-${100 + DateTime.now().millisecond % 900}';
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _nidController.dispose();
    _rateController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final id = _idController.text.trim();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final nid = _nidController.text.trim();
    final rate = double.tryParse(_rateController.text) ?? 350.0;
    final address = _addressController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Driver Name and Phone Number'), backgroundColor: AppColors.crimsonRed),
      );
      return;
    }

    setState(() => _isSaving = true);
    final driver = DriverModel(
      driverId: id,
      name: name,
      phone: phone,
      nid: nid,
      totalDue: 0.0,
      activeRickshawId: _assignedRickshawId,
      address: address,
      joinedDate: DateTime.now(),
    );

    await ref.read(fleetProvider.notifier).addDriver(driver);
    setState(() => _isSaving = false);

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Driver $name registered successfully!'), backgroundColor: AppColors.emeraldGreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fleet = ref.watch(fleetProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: SingleChildScrollView(
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
                        const Icon(Icons.person_add_rounded, color: AppColors.electricAmber),
                        const SizedBox(width: 8),
                        Text('Register New Driver', style: AppTypography.titleMedium),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GlassTextField(
                        controller: _idController,
                        labelText: 'Driver ID',
                        hintText: 'e.g. D-105',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GlassTextField(
                        controller: _rateController,
                        labelText: 'Daily Rate (৳)',
                        hintText: '350',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GlassTextField(
                  controller: _nameController,
                  labelText: 'Driver Full Name',
                  hintText: 'e.g. Karim Mia',
                ),
                const SizedBox(height: 10),
                GlassTextField(
                  controller: _phoneController,
                  labelText: 'Mobile Number',
                  hintText: 'e.g. 01711223344',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                GlassTextField(
                  controller: _nidController,
                  labelText: 'National ID (NID) No.',
                  hintText: 'e.g. 19902691234567890',
                ),
                const SizedBox(height: 10),
                // Assign Rickshaw Dropdown
                Text('Assigned Rickshaw Unit', style: AppTypography.labelMedium),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _assignedRickshawId,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF141A26),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      hint: const Text('Select Rickshaw (Optional)', style: TextStyle(color: AppColors.textTertiary, fontSize: 13)),
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryBlue),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('None (Unassigned)')),
                        ...fleet.rickshaws.map((r) => DropdownMenuItem(value: r.rickshawId, child: Text('${r.rickshawId} - ${r.modelName}'))),
                      ],
                      onChanged: (val) => setState(() => _assignedRickshawId = val),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GlassTextField(
                  controller: _addressController,
                  labelText: 'Residential Address',
                  hintText: 'e.g. Mirpur-10, Dhaka',
                ),
                const SizedBox(height: 18),
                GlassButton(
                  text: 'Save Driver Profile',
                  icon: Icons.check_circle_outline_rounded,
                  variant: GlassButtonVariant.amber,
                  isLoading: _isSaving,
                  onPressed: _handleSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
