import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../models/bmi_calculation_result.dart';
import 'bmi_scale_widget.dart';

class BmiResultCard extends StatelessWidget {
  final BmiCalculationResult result;
  final VoidCallback onRecalculate;

  const BmiResultCard({
    super.key,
    required this.result,
    required this.onRecalculate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = result.category;

    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with category tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Calculation Result',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: category.color.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(category.icon, size: 14, color: category.color),
                    const SizedBox(width: 5),
                    Text(
                      category.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: category.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Main Hero Result display
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                result.displayedBmi,
                style: AppTextStyles.resultHero.copyWith(
                  color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'BMI (kg/m²)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Context details pills: Height & Weight
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildMetaChip(
                icon: Icons.height_rounded,
                label: result.formattedHeight,
                isDark: isDark,
              ),
              _buildMetaChip(
                icon: Icons.monitor_weight_outlined,
                label: result.formattedWeight,
                isDark: isDark,
              ),
              if (result.age != null)
                _buildMetaChip(
                  icon: Icons.cake_outlined,
                  label: '${result.age} yrs',
                  isDark: isDark,
                ),
              if (result.sex != null)
                _buildMetaChip(
                  icon: Icons.person_outline_rounded,
                  label: result.sex!,
                  isDark: isDark,
                ),
            ],
          ),

          const SizedBox(height: 24),

          // Custom Horizontal BMI Scale with Marker
          BmiScaleWidget(
            bmi: result.bmi,
            category: category,
          ),

          const SizedBox(height: 22),

          // Youth / Pediatric Clinical Guidance Alert if Age < 20
          if (!result.isAdult) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.info.withValues(alpha: 0.3),
                  width: 1.0,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_rounded, color: AppColors.info, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Age Notice: Youth Assessment',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.info,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Adult BMI categories shown here are for reference only. For children and adolescents under 20, health professionals use CDC/WHO age-and-sex-specific growth chart percentiles rather than adult cutoffs.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Understanding Your Result
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 18,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'What this means',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  category.explanation,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Estimated Healthy Weight for height:',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      result.healthyWeightRangeDisplay,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Medical Disclaimer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 14,
                color: isDark ? AppColors.darkSecondaryText : AppColors.mutedText,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  AppConstants.medicalDisclaimer,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.mutedText,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Actions
          AppButton(
            label: 'Calculate Again',
            variant: AppButtonVariant.outline,
            icon: Icons.refresh_rounded,
            onPressed: onRecalculate,
          ),
        ],
      ),
    );
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
