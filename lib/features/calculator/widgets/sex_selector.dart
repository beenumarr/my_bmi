import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SexSelector extends StatelessWidget {
  final String? selectedSex;
  final ValueChanged<String?> onSexChanged;

  const SexSelector({
    super.key,
    required this.selectedSex,
    required this.onSexChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final options = [
      (label: 'Female', value: 'Female', icon: Icons.female_rounded),
      (label: 'Male', value: 'Male', icon: Icons.male_rounded),
      (label: 'Prefer not to say', value: null, icon: Icons.person_outline_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Sex (Optional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Contextual',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedSex == option.value;
            return InkWell(
              onTap: () => onSexChanged(option.value),
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                          ? AppColors.darkSurfaceSubtle
                          : AppColors.softGreen.withValues(alpha: 0.7))
                      : (isDark ? AppColors.darkSurface : AppColors.secondaryBackground),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : (isDark ? AppColors.darkBorder : AppColors.border),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      option.icon,
                      size: 16,
                      color: isSelected
                          ? AppColors.primaryGreen
                          : (isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      option.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? (isDark ? AppColors.softGreen : AppColors.darkGreen)
                            : (isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        Text(
          'Note: Biological sex does not alter the adult BMI formula, but offers helpful context for body composition discussions.',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
