import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/measurement_system.dart';

class UnitToggle extends StatelessWidget {
  final MeasurementSystem currentSystem;
  final ValueChanged<MeasurementSystem> onSystemChanged;

  const UnitToggle({
    super.key,
    required this.currentSystem,
    required this.onSystemChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildOption(
              context,
              system: MeasurementSystem.metric,
              title: 'Metric',
              subtitle: 'kg · cm',
              isSelected: currentSystem == MeasurementSystem.metric,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildOption(
              context,
              system: MeasurementSystem.imperial,
              title: 'Imperial',
              subtitle: 'lbs · ft, in',
              isSelected: currentSystem == MeasurementSystem.imperial,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required MeasurementSystem system,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onSystemChanged(system),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkSurface : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
          border: isSelected
              ? Border.all(
                  color: isDark
                      ? AppColors.primaryGreen.withValues(alpha: 0.5)
                      : AppColors.primaryGreen.withValues(alpha: 0.25),
                  width: 1.0,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? AppColors.softGreen : AppColors.primaryGreen)
                    : (isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? (isDark ? AppColors.darkSecondaryText : AppColors.secondaryText)
                    : (isDark ? AppColors.darkSecondaryText.withValues(alpha: 0.7) : AppColors.mutedText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
