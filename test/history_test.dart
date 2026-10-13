import 'package:flutter_test/flutter_test.dart';
import 'package:my_bmi/features/calculator/models/bmi_category.dart';
import 'package:my_bmi/features/calculator/models/measurement_system.dart';
import 'package:my_bmi/features/history/models/history_entry.dart';

void main() {
  group('HistoryEntry Model', () {
    test('serializes and deserializes correctly via JSON', () {
      final now = DateTime.now();
      final entry = HistoryEntry(
        id: '12345_22.9',
        bmi: 22.857,
        categoryName: BmiCategory.healthyWeight.name,
        heightDisplay: '175.0 cm',
        weightDisplay: '70.0 kg',
        systemName: MeasurementSystem.metric.name,
        age: 28,
        sex: 'Female',
        timestamp: now,
      );

      final jsonStr = entry.toJson();
      final restored = HistoryEntry.fromJson(jsonStr);

      expect(restored.id, entry.id);
      expect(restored.bmi, closeTo(22.857, 0.001));
      expect(restored.displayedBmi, '22.9');
      expect(restored.category, BmiCategory.healthyWeight);
      expect(restored.system, MeasurementSystem.metric);
      expect(restored.heightDisplay, '175.0 cm');
      expect(restored.weightDisplay, '70.0 kg');
      expect(restored.age, 28);
      expect(restored.sex, 'Female');
      expect(restored.timestamp.millisecondsSinceEpoch, now.millisecondsSinceEpoch);
    });

    test('recovers category when categoryName matches standard enum', () {
      final entry = HistoryEntry(
        id: '1',
        bmi: 31.5,
        categoryName: 'obesityClass1',
        heightDisplay: '180 cm',
        weightDisplay: '102 kg',
        systemName: 'metric',
        timestamp: DateTime.now(),
      );

      expect(entry.category, BmiCategory.obesityClass1);
    });
  });
}
