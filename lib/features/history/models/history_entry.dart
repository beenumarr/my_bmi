import 'dart:convert';
import '../../calculator/models/bmi_category.dart';
import '../../calculator/models/bmi_calculation_result.dart';
import '../../calculator/models/measurement_system.dart';

/// Represents a persistent historical BMI calculation entry.
class HistoryEntry {
  final String id;
  final double bmi;
  final String categoryName;
  final String heightDisplay;
  final String weightDisplay;
  final String systemName;
  final int? age;
  final String? sex;
  final DateTime timestamp;

  const HistoryEntry({
    required this.id,
    required this.bmi,
    required this.categoryName,
    required this.heightDisplay,
    required this.weightDisplay,
    required this.systemName,
    this.age,
    this.sex,
    required this.timestamp,
  });

  factory HistoryEntry.fromResult(BmiCalculationResult result) {
    return HistoryEntry(
      id: '${result.timestamp.millisecondsSinceEpoch}_${result.bmi.toStringAsFixed(1)}',
      bmi: result.bmi,
      categoryName: result.category.name,
      heightDisplay: result.formattedHeight,
      weightDisplay: result.formattedWeight,
      systemName: result.system.name,
      age: result.age,
      sex: result.sex,
      timestamp: result.timestamp,
    );
  }

  BmiCategory get category =>
      BmiCategory.values.firstWhere(
        (c) => c.name == categoryName,
        orElse: () => BmiCategory.fromBmi(bmi),
      );

  MeasurementSystem get system =>
      MeasurementSystem.values.firstWhere(
        (s) => s.name == systemName,
        orElse: () => MeasurementSystem.metric,
      );

  String get displayedBmi => bmi.toStringAsFixed(1);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bmi': bmi,
      'categoryName': categoryName,
      'heightDisplay': heightDisplay,
      'weightDisplay': weightDisplay,
      'systemName': systemName,
      'age': age,
      'sex': sex,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory HistoryEntry.fromMap(Map<String, dynamic> map) {
    return HistoryEntry(
      id: map['id'] as String,
      bmi: (map['bmi'] as num).toDouble(),
      categoryName: map['categoryName'] as String,
      heightDisplay: map['heightDisplay'] as String,
      weightDisplay: map['weightDisplay'] as String,
      systemName: map['systemName'] as String? ?? 'metric',
      age: map['age'] as int?,
      sex: map['sex'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryEntry.fromJson(String source) =>
      HistoryEntry.fromMap(json.decode(source) as Map<String, dynamic>);
}
