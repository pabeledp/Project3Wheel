import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import 'liquid_glass_container.dart';

class GlassTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const GlassTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTypography.labelMedium.copyWith(
              color: _isFocused ? AppColors.primaryBlue : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        LiquidGlassContainer(
          borderRadius: AppDimensions.borderRadiusMedium,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          color: _isFocused ? AppColors.glassWhiteMedium : AppColors.glassWhiteLight,
          borderGradient: _isFocused ? AppColors.activeBorderGradient : AppColors.specularBorderGradient,
          borderWidth: _isFocused ? 1.5 : 1.0,
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            validator: widget.validator,
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            style: AppTypography.bodyLarge,
            cursorColor: AppColors.primaryBlue,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused ? AppColors.primaryBlue : AppColors.textSecondary,
                      size: 20,
                    )
                  : null,
              suffixIcon: widget.suffix,
            ),
          ),
        ),
      ],
    );
  }
}
