enum MeasurementSystem {
  metric,
  imperial;

  String get displayName => switch (this) {
        MeasurementSystem.metric => 'Metric',
        MeasurementSystem.imperial => 'Imperial',
      };

  String get heightUnit => switch (this) {
        MeasurementSystem.metric => 'cm',
        MeasurementSystem.imperial => 'ft / in',
      };

  String get weightUnit => switch (this) {
        MeasurementSystem.metric => 'kg',
        MeasurementSystem.imperial => 'lbs',
      };
}
