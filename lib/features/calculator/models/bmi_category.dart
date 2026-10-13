import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Clinical adult BMI categories according to the World Health Organization (WHO)
/// and CDC standards.
enum BmiCategory {
  underweight,
  healthyWeight,
  overweight,
  obesityClass1,
  obesityClass2,
  obesityClass3;

  String get label => switch (this) {
        BmiCategory.underweight => 'Underweight',
        BmiCategory.healthyWeight => 'Healthy Weight',
        BmiCategory.overweight => 'Overweight',
        BmiCategory.obesityClass1 => 'Obesity Class I',
        BmiCategory.obesityClass2 => 'Obesity Class II',
        BmiCategory.obesityClass3 => 'Obesity Class III',
      };

  String get rangeLabel => switch (this) {
        BmiCategory.underweight => '< 18.5',
        BmiCategory.healthyWeight => '18.5 – 24.9',
        BmiCategory.overweight => '25.0 – 29.9',
        BmiCategory.obesityClass1 => '30.0 – 34.9',
        BmiCategory.obesityClass2 => '35.0 – 39.9',
        BmiCategory.obesityClass3 => '≥ 40.0',
      };

  Color get color => switch (this) {
        BmiCategory.underweight => AppColors.bmiUnderweight,
        BmiCategory.healthyWeight => AppColors.bmiHealthy,
        BmiCategory.overweight => AppColors.bmiOverweight,
        BmiCategory.obesityClass1 => AppColors.bmiObese1,
        BmiCategory.obesityClass2 => AppColors.bmiObese2,
        BmiCategory.obesityClass3 => AppColors.bmiObese3,
      };

  IconData get icon => switch (this) {
        BmiCategory.underweight => Icons.info_outline_rounded,
        BmiCategory.healthyWeight => Icons.check_circle_outline_rounded,
        BmiCategory.overweight => Icons.insights_rounded,
        BmiCategory.obesityClass1 => Icons.health_and_safety_outlined,
        BmiCategory.obesityClass2 => Icons.health_and_safety_outlined,
        BmiCategory.obesityClass3 => Icons.medical_services_outlined,
      };

  /// Respectful, scientifically responsible explanation without fear-based language or body shaming.
  String get explanation => switch (this) {
        BmiCategory.underweight =>
          'Your result falls below the typical healthy weight range for adults. This may be linked to insufficient caloric intake, high metabolism, or other factors. Discussing your nutrition with a doctor or dietitian can help support your overall energy and vitality.',
        BmiCategory.healthyWeight =>
          'Your result falls within the standard healthy weight range for adults. Maintaining balanced nutrition and regular physical activity supports cardiovascular fitness and long-term health.',
        BmiCategory.overweight =>
          'Your result is slightly above the standard healthy weight range. For some individuals, this may reflect higher muscle mass, bone density, or body composition variations. Consider speaking with a healthcare professional about balanced daily habits.',
        BmiCategory.obesityClass1 =>
          'Your result falls within the Obesity Class I range. BMI is an initial screening parameter. A healthcare provider can offer personalized, holistic guidance regarding nutrition, cardiovascular wellness, and metabolic health.',
        BmiCategory.obesityClass2 =>
          'Your result falls within Obesity Class II. We recommend partnering with a healthcare provider for a thorough wellness check that evaluates lifestyle, metabolic indicators, and individualized health goals.',
        BmiCategory.obesityClass3 =>
          'Your result falls within Obesity Class III. Connecting with a medical team can provide supportive, tailored strategies to optimize metabolic function, mobility, and long-term vitality.',
      };

  /// Classifies a raw BMI value according to standard WHO adult boundaries.
  /// Strict thresholds:
  /// < 18.5: underweight
  /// 18.5 <= bmi < 25.0: healthyWeight
  /// 25.0 <= bmi < 30.0: overweight
  /// 30.0 <= bmi < 35.0: obesityClass1
  /// 35.0 <= bmi < 40.0: obesityClass2
  /// >= 40.0: obesityClass3
  static BmiCategory fromBmi(double bmi) {
    if (bmi < 18.5) {
      return BmiCategory.underweight;
    } else if (bmi < 25.0) {
      return BmiCategory.healthyWeight;
    } else if (bmi < 30.0) {
      return BmiCategory.overweight;
    } else if (bmi < 35.0) {
      return BmiCategory.obesityClass1;
    } else if (bmi < 40.0) {
      return BmiCategory.obesityClass2;
    } else {
      return BmiCategory.obesityClass3;
    }
  }
}
