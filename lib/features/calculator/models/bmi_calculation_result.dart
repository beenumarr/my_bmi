import 'bmi_category.dart';
import 'measurement_system.dart';

/// Encapsulates the complete result of a BMI calculation.
class BmiCalculationResult {
  /// The unrounded, raw BMI value used for exact clinical categorization.
  final double bmi;

  /// The clinical category evaluated on the raw BMI value.
  final BmiCategory category;

  /// Measurement system used at calculation time.
  final MeasurementSystem system;

  /// Numerical height value (cm or feet/inches equivalent).
  final double heightCm;

  /// Numerical weight value (kg).
  final double weightKg;

  /// Formatted height string for presentation (e.g. "175.0 cm" or "5 ft 9 in").
  final String formattedHeight;

  /// Formatted weight string for presentation (e.g. "68.5 kg" or "151.0 lbs").
  final String formattedWeight;

  /// Optional age of the user.
  final int? age;

  /// Optional biological sex reference context.
  final String? sex;

  /// Timestamp of calculation.
  final DateTime timestamp;

  const BmiCalculationResult({
    required this.bmi,
    required this.category,
    required this.system,
    required this.heightCm,
    required this.weightKg,
    required this.formattedHeight,
    required this.formattedWeight,
    this.age,
    this.sex,
    required this.timestamp,
  });

  /// The displayed BMI rounded to exactly one decimal place.
  String get displayedBmi => bmi.toStringAsFixed(1);

  /// True if the user is considered an adult for standard BMI guidelines (age >= 20).
  /// If age is omitted, standard adult guidelines are assumed with a gentle reminder.
  bool get isAdult => age == null || age! >= 20;

  /// Normalized position of the BMI on a visual reference scale of 15.0 to 45.0.
  /// Clamped between 0.0 and 1.0.
  double get scaleRatio {
    const minScale = 15.0;
    const maxScale = 45.0;
    if (bmi <= minScale) return 0.0;
    if (bmi >= maxScale) return 1.0;
    return (bmi - minScale) / (maxScale - minScale);
  }

  /// Healthy weight range for this person's height in kilograms (for educational context)
  /// Lower bound: BMI 18.5 -> kg = 18.5 * (heightMeters^2)
  /// Upper bound: BMI 24.9 -> kg = 24.9 * (heightMeters^2)
  double get minHealthyWeightKg {
    final heightM = heightCm / 100.0;
    return 18.5 * (heightM * heightM);
  }

  double get maxHealthyWeightKg {
    final heightM = heightCm / 100.0;
    return 24.9 * (heightM * heightM);
  }

  String get healthyWeightRangeDisplay {
    if (system == MeasurementSystem.metric) {
      return '${minHealthyWeightKg.toStringAsFixed(1)} – ${maxHealthyWeightKg.toStringAsFixed(1)} kg';
    } else {
      final minLbs = minHealthyWeightKg * 2.20462262;
      final maxLbs = maxHealthyWeightKg * 2.20462262;
      return '${minLbs.toStringAsFixed(1)} – ${maxLbs.toStringAsFixed(1)} lbs';
    }
  }
}
