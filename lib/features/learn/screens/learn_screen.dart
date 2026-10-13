import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../../calculator/models/bmi_category.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About BMI',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Introduction Banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.softGreen,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.primaryGreen.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.school_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Educational Guide',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.softGreen
                                  : AppColors.darkGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Learn how Body Mass Index is calculated, how to interpret numbers responsibly, and its clinical boundaries.',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkSecondaryText
                                  : AppColors.secondaryText,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 1. What is BMI?
              _buildSectionHeader('1. What is BMI?', isDark),
              const SizedBox(height: 10),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Body Mass Index (BMI) is a standardized screening measurement derived from an individual’s body weight and height.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Established originally by Belgian mathematician Adolphe Quetelet in the 19th century, BMI provides an inexpensive, population-level estimate to categorize body weight relative to stature. It is widely used by public health organizations, including the World Health Organization (WHO) and the Centers for Disease Control and Prevention (CDC).',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 2. How is BMI Calculated?
              _buildSectionHeader('2. How is BMI Calculated?', isDark),
              const SizedBox(height: 10),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormulaBox(
                      title: 'Metric Formula',
                      formula: 'BMI = weight (kg) ÷ [height (m)]²',
                      example: 'Example: 70 kg ÷ (1.75 m × 1.75 m) = 22.86 kg/m²',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 14),
                    _buildFormulaBox(
                      title: 'Imperial Formula',
                      formula: 'BMI = 703 × weight (lbs) ÷ [height (in)]²',
                      example: 'Example: 703 × 154 lbs ÷ (69 in × 69 in) = 22.74',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Understanding Adult BMI Categories
              _buildSectionHeader('3. Adult BMI Categories', isDark),
              const SizedBox(height: 6),
              Text(
                'Standard World Health Organization (WHO) classifications for adults 20+:',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: BmiCategory.values.map((cat) {
                    final isLast = cat == BmiCategory.values.last;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: cat.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cat.label,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.darkPrimaryText
                                            : AppColors.primaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Standard range: ${cat.rangeLabel}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? AppColors.darkSecondaryText
                                            : AppColors.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: cat.color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  cat.rangeLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: cat.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast) const Divider(height: 1),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // 4. Clinical Limitations of BMI
              _buildSectionHeader('4. Limitations of BMI', isDark),
              const SizedBox(height: 10),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLimitationItem(
                      icon: Icons.fitness_center_rounded,
                      title: 'Muscle Mass vs. Body Fat',
                      body:
                          'BMI does not distinguish between lean muscle tissue, bone density, and adipose fat. Muscular athletes often register as "overweight" or "obese" despite low body fat percentages.',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 14),
                    _buildLimitationItem(
                      icon: Icons.child_care_rounded,
                      title: 'Children and Adolescents',
                      body:
                          'Standard adult thresholds cannot be applied to individuals under 20. For youth, growth rates and sex differences require age-specific percentile growth charts.',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 14),
                    _buildLimitationItem(
                      icon: Icons.pregnant_woman_rounded,
                      title: 'Pregnancy & Nursing',
                      body:
                          'BMI is not designed to assess gestational weight gain or maternal body composition during pregnancy and the immediate postpartum period.',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 14),
                    _buildLimitationItem(
                      icon: Icons.elderly_rounded,
                      title: 'Older Adults & Bone Density',
                      body:
                          'As individuals age, lean muscle mass naturally decreases. Mildly higher BMI values in older populations can sometimes be protective against frailty and bone fractures.',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 5. Scientific Responsibility & Next Steps
              AppCard(
                color: isDark ? AppColors.darkSurface : AppColors.secondaryBackground,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          size: 20,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Responsible Health Guidance',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.darkPrimaryText
                                  : AppColors.primaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'BMI is merely one piece of the health puzzle. True metabolic health encompasses blood pressure, lipid profile, blood glucose, cardiovascular endurance, nutrition, sleep quality, and mental well-being. Always consult a qualified medical professional for health diagnoses.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: AppTextStyles.headingSmall.copyWith(
        color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
      ),
    );
  }

  Widget _buildFormulaBox({
    required String title,
    required String formula,
    required String example,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formula,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
              color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            example,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitationItem({
    required IconData icon,
    required String title,
    required String body,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primaryGreen),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                body,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
