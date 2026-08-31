import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../widgets/glass/liquid_glass_container.dart';
import '../../widgets/glass/glass_button.dart';
import '../../widgets/glass/glass_pill_badge.dart';
import '../../widgets/layout/responsive_layout_builder.dart';

class GpsTrackingPlaceholderScreen extends StatefulWidget {
  const GpsTrackingPlaceholderScreen({super.key});

  @override
  State<GpsTrackingPlaceholderScreen> createState() => _GpsTrackingPlaceholderScreenState();
}

class _GpsTrackingPlaceholderScreenState extends State<GpsTrackingPlaceholderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidGlassBackgroundScaffold(
      appBar: AppBar(
        title: Text('IoT Fleet Telematics', style: AppTypography.titleMedium),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing Animated Glass Sphere with Satellite Orbit
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ambient Orb Glow
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.4),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      // Outer Radar Rings
                      Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryBlue.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                      ),
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                      ),
                      // Core Frosted Glass Orb
                      LiquidGlassContainer(
                        width: 120,
                        height: 120,
                        borderRadius: BorderRadius.circular(999),
                        color: AppColors.glassWhiteMedium,
                        borderWidth: 2,
                        borderGradient: AppColors.primaryGradient,
                        child: const Center(
                          child: Icon(
                            Icons.electric_rickshaw_rounded,
                            size: 54,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Orbiting Satellite Graphic
                      AnimatedBuilder(
                        animation: _rotationController,
                        builder: (context, child) {
                          final angle = _rotationController.value * 2 * math.pi;
                          final radius = 95.0;
                          final x = radius * math.cos(angle);
                          final y = radius * math.sin(angle);

                          return Transform.translate(
                            offset: Offset(x, y),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accentCyan,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentCyan.withOpacity(0.8),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.satellite_alt_rounded,
                                size: 14,
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                // Status Pill
                const GlassPillBadge(
                  text: 'FIRMWARE V2.0 PENDING',
                  variant: GlassPillVariant.amber,
                  showDot: true,
                ),
                const SizedBox(height: 16),
                Text(
                  'GPS Tracking Coming Soon',
                  style: AppTypography.displayMedium.copyWith(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Real-time rickshaw location, speed monitoring, and geo-fencing will be available in the next firmware update.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                // Schema Intact Preview Card
                LiquidGlassContainer(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.glassDarkLight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.code_rounded, size: 16, color: AppColors.accentCyan),
                          const SizedBox(width: 8),
                          Text('IoT Telematics Schema Intact', style: AppTypography.labelSmall.copyWith(color: AppColors.accentCyan)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'rickshaws.last_location: { lat, lng, speed, updated_at }\nBackend ready for SIM800L / GPS tracker packets.',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // Disabled Apple-style glass button
                GlassButton(
                  text: 'View Live Map (Disabled)',
                  icon: Icons.map_outlined,
                  variant: GlassButtonVariant.secondary,
                  onPressed: null, // Disabled per Phase 4 specs
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
