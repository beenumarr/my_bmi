import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final String? unit;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool isRequired;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.unit,
    this.prefixIcon,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.inputFormatters,
    this.onChanged,
    this.focusNode,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    size: 20,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  )
                : null,
            suffixIcon: unit != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Center(
                      widthFactor: 1.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.softGreenDark
                              : AppColors.softGreen.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? AppColors.primaryGreenDark.withValues(alpha: 0.35)
                                : AppColors.primaryGreen.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          unit!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.primaryGreenDark
                                : AppColors.darkGreen,
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
        if (helperText != null && errorText == null) ...[
          const SizedBox(height: 5),
          Text(
            helperText!,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
            ),
          ),
        ],
      ],
    );
  }
}
