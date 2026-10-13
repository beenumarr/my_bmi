/// Central application constants and clinical limits for MyBMI.
class AppConstants {
  AppConstants._();

  static const String appName = 'MyBMI';
  static const String appTagline = 'Understand your body.';
  static const String appSubhead =
      'A simple way to check your BMI and understand what it means.';
  static const String appVersion = '1.0.0';

  // Medical reference threshold
  static const int adultAgeThreshold = 20;

  // Validation bounds - Metric
  static const double minHeightCm = 50.0;
  static const double maxHeightCm = 260.0;
  static const double minWeightKg = 10.0;
  static const double maxWeightKg = 450.0;

  // Validation bounds - Imperial
  static const int minFeet = 1;
  static const int maxFeet = 8;
  static const double minInches = 0.0;
  static const double maxInches = 11.9;
  static const double minWeightLbs = 22.0;
  static const double maxWeightLbs = 992.0;

  // Age bounds
  static const int minAge = 1;
  static const int maxAge = 120;

  // Conversion constants
  static const double inchesToCm = 2.54;
  static const double kgToLbs = 2.20462262;

  // SharedPreferences Keys
  static const String keyMeasurementSystem = 'mybmi_system_pref';
  static const String keyThemeMode = 'mybmi_theme_pref';
  static const String keyHistory = 'mybmi_history_records';

  // Medical Disclaimer
  static const String medicalDisclaimer =
      'MyBMI provides estimates based on standard epidemiological formulas. '
      'Body Mass Index is a screening metric, not a diagnostic assessment of body composition or individual health. '
      'For comprehensive medical guidance, consult a qualified healthcare provider or registered dietitian.';

  static const String youthNotice =
      'Notice: Standard adult BMI categories apply only to individuals aged 20 and older. '
      'For children and teens under 20, BMI percentiles based on clinical growth charts (CDC/WHO) are required.';
}
