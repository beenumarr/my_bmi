import 'package:flutter_test/flutter_test.dart';
import 'package:my_bmi/features/calculator/models/bmi_category.dart';
import 'package:my_bmi/features/calculator/models/measurement_system.dart';
import 'package:my_bmi/features/calculator/services/bmi_calculator_service.dart';

void main() {
  const service = BmiCalculatorService();

  group('Metric BMI Calculations', () {
    test('accurately calculates normal BMI in metric', () {
      // 175 cm, 70 kg -> BMI = 70 / (1.75^2) = 22.857142857...
      final result = service.calculateMetric(
        heightCm: 175.0,
        weightKg: 70.0,
        age: 25,
      );

      expect(result.bmi, closeTo(22.857, 0.001));
      expect(result.displayedBmi, '22.9');
      expect(result.category, BmiCategory.healthyWeight);
      expect(result.isAdult, isTrue);
      expect(result.system, MeasurementSystem.metric);
      expect(result.formattedHeight, '175.0 cm');
      expect(result.formattedWeight, '70.0 kg');
    });

    test('accurately calculates underweight metric BMI', () {
      // 180 cm, 50 kg -> 50 / (1.80^2) = 15.432...
      final result = service.calculateMetric(
        heightCm: 180.0,
        weightKg: 50.0,
      );

      expect(result.bmi, closeTo(15.43, 0.01));
      expect(result.displayedBmi, '15.4');
      expect(result.category, BmiCategory.underweight);
    });

    test('accurately calculates obesity class 3 metric BMI', () {
      // 170 cm, 130 kg -> 130 / (1.70^2) = 44.982...
      final result = service.calculateMetric(
        heightCm: 170.0,
        weightKg: 130.0,
      );

      expect(result.bmi, closeTo(44.98, 0.01));
      expect(result.category, BmiCategory.obesityClass3);
    });

    test('rejects zero or negative measurements with ArgumentError', () {
      expect(
        () => service.calculateMetric(heightCm: 0, weightKg: 70),
        throwsArgumentError,
      );
      expect(
        () => service.calculateMetric(heightCm: 170, weightKg: 0),
        throwsArgumentError,
      );
      expect(
        () => service.calculateMetric(heightCm: -170, weightKg: 70),
        throwsArgumentError,
      );
    });
  });

  group('Imperial BMI Calculations', () {
    test('accurately calculates normal BMI in imperial', () {
      // 5 ft 9 in = 69 in, 154 lbs
      // BMI = 703 * 154 / (69 * 69) = 108262 / 4761 = 22.7393...
      final result = service.calculateImperial(
        feet: 5,
        inches: 9.0,
        weightLbs: 154.0,
        age: 30,
      );

      expect(result.bmi, closeTo(22.74, 0.01));
      expect(result.displayedBmi, '22.7');
      expect(result.category, BmiCategory.healthyWeight);
      expect(result.system, MeasurementSystem.imperial);
      expect(result.formattedHeight, '5 ft 9 in');
      expect(result.formattedWeight, '154.0 lbs');
    });

    test('rejects zero imperial height with ArgumentError', () {
      expect(
        () => service.calculateImperial(feet: 0, inches: 0, weightLbs: 150),
        throwsArgumentError,
      );
    });
  });

  group('Unit Conversions', () {
    test('converts cm to feet and inches accurately', () {
      // 175 cm / 2.54 = 68.8976 inches = 5 feet 8.9 inches
      final converted = service.convertCmToFeetInches(175.0);
      expect(converted.feet, 5);
      expect(converted.inches, closeTo(8.9, 0.1));
    });

    test('converts feet and inches to cm accurately', () {
      // 5 ft 9 in = 69 in * 2.54 = 175.26 cm -> 175.3 cm
      final cm = service.convertFeetInchesToCm(5, 9.0);
      expect(cm, closeTo(175.3, 0.1));
    });

    test('converts kg to lbs and vice versa accurately', () {
      const kg = 70.0;
      final lbs = service.convertKgToLbs(kg);
      expect(lbs, closeTo(154.3, 0.1));

      final backToKg = service.convertLbsToKg(lbs);
      expect(backToKg, closeTo(70.0, 0.2));
    });
  });

  group('BMI Category Boundaries', () {
    test('exact boundary classifications', () {
      expect(BmiCategory.fromBmi(18.49), BmiCategory.underweight);
      expect(BmiCategory.fromBmi(18.5), BmiCategory.healthyWeight);
      expect(BmiCategory.fromBmi(24.99), BmiCategory.healthyWeight);
      expect(BmiCategory.fromBmi(25.0), BmiCategory.overweight);
      expect(BmiCategory.fromBmi(29.99), BmiCategory.overweight);
      expect(BmiCategory.fromBmi(30.0), BmiCategory.obesityClass1);
      expect(BmiCategory.fromBmi(34.99), BmiCategory.obesityClass1);
      expect(BmiCategory.fromBmi(35.0), BmiCategory.obesityClass2);
      expect(BmiCategory.fromBmi(39.99), BmiCategory.obesityClass2);
      expect(BmiCategory.fromBmi(40.0), BmiCategory.obesityClass3);
      expect(BmiCategory.fromBmi(55.0), BmiCategory.obesityClass3);
    });

    test('unrounded categorization test (boundary rounding check)', () {
      // A raw BMI of 24.96 should classify as healthyWeight,
      // even if displayed rounded to 1 decimal as "25.0"
      final result = service.calculateMetric(
        heightCm: 175.0,
        weightKg: 76.44, // 76.44 / (1.75^2) = 24.96
      );

      expect(result.bmi, lessThan(25.0));
      expect(result.category, BmiCategory.healthyWeight);
      expect(result.displayedBmi, '25.0');
    });
  });

  group('Age-Related Interpretation Rules', () {
    test('recognizes adults aged 20 and above', () {
      final adultResult = service.calculateMetric(
        heightCm: 170,
        weightKg: 65,
        age: 20,
      );
      expect(adultResult.isAdult, isTrue);

      final olderAdult = service.calculateMetric(
        heightCm: 170,
        weightKg: 65,
        age: 65,
      );
      expect(olderAdult.isAdult, isTrue);
    });

    test('recognizes youth under 20 as requiring pediatric growth charts', () {
      final childResult = service.calculateMetric(
        heightCm: 140,
        weightKg: 35,
        age: 12,
      );
      expect(childResult.isAdult, isFalse);

      final teenResult = service.calculateMetric(
        heightCm: 165,
        weightKg: 55,
        age: 19,
      );
      expect(teenResult.isAdult, isFalse);
    });

    test('null age assumes adult standard interpretation', () {
      final result = service.calculateMetric(
        heightCm: 170,
        weightKg: 65,
        age: null,
      );
      expect(result.isAdult, isTrue);
    });
  });

  group('Input Validation', () {
    test('validates metric height correctly', () {
      expect(service.validateHeightCm(null), isNotNull);
      expect(service.validateHeightCm(''), isNotNull);
      expect(service.validateHeightCm('abc'), isNotNull);
      expect(service.validateHeightCm('40'), isNotNull); // below 50 cm
      expect(service.validateHeightCm('300'), isNotNull); // above 260 cm
      expect(service.validateHeightCm('175.5'), isNull); // valid
    });

    test('validates metric weight correctly', () {
      expect(service.validateWeightKg(null), isNotNull);
      expect(service.validateWeightKg(''), isNotNull);
      expect(service.validateWeightKg('xyz'), isNotNull);
      expect(service.validateWeightKg('5'), isNotNull); // below 10 kg
      expect(service.validateWeightKg('500'), isNotNull); // above 450 kg
      expect(service.validateWeightKg('72.4'), isNull); // valid
    });

    test('validates imperial inputs correctly', () {
      expect(service.validateFeet('0'), isNotNull);
      expect(service.validateFeet('9'), isNotNull);
      expect(service.validateFeet('5'), isNull);

      expect(service.validateInches('-1'), isNotNull);
      expect(service.validateInches('12'), isNotNull);
      expect(service.validateInches('8.5'), isNull);

      expect(service.validateWeightLbs('15'), isNotNull); // below 22 lbs
      expect(service.validateWeightLbs('1000'), isNotNull); // above 992 lbs
      expect(service.validateWeightLbs('160'), isNull);
    });

    test('validates age correctly', () {
      expect(service.validateAge(null), isNull); // optional
      expect(service.validateAge(''), isNull); // optional
      expect(service.validateAge('0'), isNotNull);
      expect(service.validateAge('130'), isNotNull);
      expect(service.validateAge('35'), isNull);
    });
  });

  group('BMI Scale Ratio Positioning', () {
    test('clamps scale ratio within bounds [0.0, 1.0]', () {
      final lowBmi = service.calculateMetric(heightCm: 200, weightKg: 40); // BMI 10
      expect(lowBmi.scaleRatio, 0.0);

      final highBmi = service.calculateMetric(heightCm: 150, weightKg: 150); // BMI 66.6
      expect(highBmi.scaleRatio, 1.0);

      // Mid-scale test: BMI 30.0 (span 15.0 to 45.0, so 15 / 30 = 0.5)
      final midResult = service.calculateMetric(heightCm: 100, weightKg: 30);
      expect(midResult.scaleRatio, closeTo(0.5, 0.01));
    });
  });
}
