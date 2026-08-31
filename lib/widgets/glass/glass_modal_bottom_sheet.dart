import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class GlassModalBottomSheet {
  GlassModalBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool enableDrag = true,
    double maxHeightFraction = 0.85,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      elevation: 0,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * maxHeightFraction,
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard.withOpacity(0.85),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusExtraLarge),
                topRight: Radius.circular(AppDimensions.radiusExtraLarge),
              ),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.25), width: 1.2),
                left: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5),
                right: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 32,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                // Apple-style drag handle
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(child: child),
              ],
            ),
          ),
        );
      },
    );
  }
}
