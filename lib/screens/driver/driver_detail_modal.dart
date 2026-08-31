import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_utils.dart';
import '../../models/driver_model.dart';
import '../../services/sms/sms_gateway_service.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/glass/glass_pill_badge.dart';

class DriverDetailModal extends ConsumerStatefulWidget {
  final DriverModel driver;

  const DriverDetailModal({super.key, required this.driver});

  @override
  ConsumerState<DriverDetailModal> createState() => _DriverDetailModalState();
}

class _DriverDetailModalState extends ConsumerState<DriverDetailModal> {
  bool _isSendingSms = false;

  void _sendSms() async {
    setState(() => _isSendingSms = true);
    final smsService = SmsGatewayService();
    final log = await smsService.sendDueReminder(
      driverId: widget.driver.driverId,
      driverName: widget.driver.name,
      driverPhone: widget.driver.phone,
      dueAmount: widget.driver.totalDue,
    );

    if (!mounted) return;
    setState(() => _isSendingSms = false);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: log.isSuccess ? AppColors.emeraldGreen : AppColors.crimsonRed,
        content: Text(log.isSuccess ? 'Bengali SMS sent to ${widget.driver.name}!' : 'SMS dispatch failed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final driver = widget.driver;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryBlue.withOpacity(0.3),
                child: Text(
                  driver.name[0],
                  style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driver.name, style: AppTypography.titleMedium),
                    const SizedBox(height: 2),
                    Text('Driver ID: ${driver.driverId} • ${driver.phone}',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (driver.hasDue)
                const GlassPillBadge(text: 'DEFAULTER', variant: GlassPillVariant.crimson, showDot: true)
              else
                const GlassPillBadge(text: 'CLEAR', variant: GlassPillVariant.emerald, showDot: true),
            ],
          ),
          const SizedBox(height: 20),
          // Due & Details Cards
          LiquidGlassContainer(
            padding: const EdgeInsets.all(16),
            color: AppColors.glassWhiteLight,
            child: Column(
              children: [
                _buildInfoRow('Active Rickshaw', driver.activeRickshawId ?? 'None Assigned'),
                const Divider(color: Colors.white12, height: 16),
                _buildInfoRow('National ID (NID)', driver.nid),
                const Divider(color: Colors.white12, height: 16),
                _buildInfoRow('Residential Address', driver.address),
                const Divider(color: Colors.white12, height: 16),
                _buildInfoRow('Member Since', AppDateUtils.formatDate(driver.joinedDate)),
                const Divider(color: Colors.white12, height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Outstanding Due', style: AppTypography.labelMedium),
                    Text(
                      CurrencyFormatter.formatBDT(driver.totalDue),
                      style: AppTypography.financialAmount.copyWith(
                        color: driver.hasDue ? AppColors.crimsonRedLight : AppColors.emeraldGreenLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Action Buttons
          Row(
            children: [
              if (driver.hasDue)
                Expanded(
                  child: GlassButton(
                    text: 'Send SMS Reminder',
                    icon: Icons.sms_outlined,
                    variant: GlassButtonVariant.amber,
                    isLoading: _isSendingSms,
                    onPressed: _sendSms,
                  ),
                ),
              if (driver.hasDue) const SizedBox(width: 12),
              Expanded(
                child: GlassButton(
                  text: 'Close',
                  variant: GlassButtonVariant.secondary,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
