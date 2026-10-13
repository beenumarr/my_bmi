import '../../../core/constants/app_constants.dart';
import '../models/bmi_category.dart';
import '../models/bmi_calculation_result.dart';
import '../models/measurement_system.dart';

/// Service responsible for rigorous BMI calculation, unit conversions, and validation.
class BmiCalculatorService {
  const BmiCalculatorService();

  /// Calculates BMI from metric inputs (height in cm, weight in kg).
  BmiCalculationResult calculateMetric({
    required double heightCm,
    required double weightKg,
    int? age,
    String? sex,
  }) {
    if (heightCm <= 0) {
      throw ArgumentError('Height must be greater than zero.');
    }
    if (weightKg <= 0) {
      throw ArgumentError('Weight must be greater than zero.');
    }

    final heightMeters = heightCm / 100.0;
    final bmi = weightKg / (heightMeters * heightMeters);
    final category = BmiCategory.fromBmi(bmi);

    return BmiCalculationResult(
      bmi: bmi,
      category: category,
      system: MeasurementSystem.metric,
      heightCm: heightCm,
      weightKg: weightKg,
      formattedHeight: '${heightCm.toStringAsFixed(1)} cm',
      formattedWeight: '${weightKg.toStringAsFixed(1)} kg',
      age: age,
      sex: sex,
      timestamp: DateTime.now(),
    );
  }

  /// Calculates BMI from imperial inputs (height in feet & inches, weight in pounds).
  BmiCalculationResult calculateImperial({
    required int feet,
    required double inches,
    required double weightLbs,
    int? age,
    String? sex,
  }) {
    final totalInches = (feet * 12.0) + inches;
    if (totalInches <= 0) {
      throw ArgumentError('Total height must be greater than zero.');
    }
    if (weightLbs <= 0) {
      throw ArgumentError('Weight must be greater than zero.');
    }

    // Standard imperial formula: 703 * weight (lbs) / (height (in)^2)
    final bmi = 703.0 * weightLbs / (totalInches * totalInches);
    final category = BmiCategory.fromBmi(bmi);

    final heightCm = totalInches * AppConstants.inchesToCm;
    final weightKg = weightLbs / AppConstants.kgToLbs;

    return BmiCalculationResult(
      bmi: bmi,
      category: category,
      system: MeasurementSystem.imperial,
      heightCm: heightCm,
      weightKg: weightKg,
      formattedHeight: '$feet ft ${inches.toStringAsFixed(0)} in',
      formattedWeight: '${weightLbs.toStringAsFixed(1)} lbs',
      age: age,
      sex: sex,
      timestamp: DateTime.now(),
    );
  }

  // --- Validation Methods ---

  String? validateHeightCm(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your height';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Please enter a valid number';
    }
    if (parsed < AppConstants.minHeightCm || parsed > AppConstants.maxHeightCm) {
      return 'Height must be between ${AppConstants.minHeightCm.toInt()} and ${AppConstants.maxHeightCm.toInt()} cm';
    }
    return null;
  }

  String? validateWeightKg(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your weight';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Please enter a valid number';
    }
    if (parsed < AppConstants.minWeightKg || parsed > AppConstants.maxWeightKg) {
      return 'Weight must be between ${AppConstants.minWeightKg.toInt()} and ${AppConstants.maxWeightKg.toInt()} kg';
    }
    return null;
  }

  String? validateFeet(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter feet';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Invalid feet';
    }
    if (parsed < AppConstants.minFeet || parsed > AppConstants.maxFeet) {
      return '${AppConstants.minFeet}–${AppConstants.maxFeet} ft';
    }
    return null;
  }

  String? validateInches(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter inches';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Invalid inches';
    }
    if (parsed < AppConstants.minInches || parsed > AppConstants.maxInches) {
      return '0–11 inches';
    }
    return null;
  }

  String? validateWeightLbs(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your weight';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Please enter a valid number';
    }
    if (parsed < AppConstants.minWeightLbs || parsed > AppConstants.maxWeightLbs) {
      return 'Weight must be between ${AppConstants.minWeightLbs.toInt()} and ${AppConstants.maxWeightLbs.toInt()} lbs';
    }
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Age is optional
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a whole number for age';
    }
    if (parsed < AppConstants.minAge || parsed > AppConstants.maxAge) {
      return 'Age must be between ${AppConstants.minAge} and ${AppConstants.maxAge}';
    }
    return null;
  }

  // --- Conversion Methods ---

  /// Converts height in centimeters to feet and inches.
  ({int feet, double inches}) convertCmToFeetInches(double cm) {
    final totalInches = cm / AppConstants.inchesToCm;
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return (feet: feet, inches: double.parse(inches.toStringAsFixed(1)));
  }

  /// Converts feet and inches to centimeters.
  double convertFeetInchesToCm(int feet, double inches) {
    final totalInches = (feet * 12.0) + inches;
    final cm = totalInches * AppConstants.inchesToCm;
    return double.parse(cm.toStringAsFixed(1));
  }

  /// Converts kilograms to pounds.
  double convertKgToLbs(double kg) {
    final lbs = kg * AppConstants.kgToLbs;
    return double.parse(lbs.toStringAsFixed(1));
  }

  /// Converts pounds to kilograms.
  double convertLbsToKg(double lbs) {
    final kg = lbs / AppConstants.kgToLbs;
    return double.parse(kg.toStringAsFixed(1));
  }
}
