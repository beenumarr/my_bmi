import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../calculator/models/measurement_system.dart';

/// Manages user preferences: unit system and theme mode.
class SettingsService extends ChangeNotifier {
  MeasurementSystem _defaultSystem = MeasurementSystem.metric;
  ThemeMode _themeMode = ThemeMode.light;
  bool _isLoaded = false;

  MeasurementSystem get defaultSystem => _defaultSystem;
  ThemeMode get themeMode => _themeMode;
  bool get isLoaded => _isLoaded;

  Future<void> init() async {
    if (_isLoaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final systemStr = prefs.getString(AppConstants.keyMeasurementSystem);
      if (systemStr != null) {
        _defaultSystem = MeasurementSystem.values.firstWhere(
          (s) => s.name == systemStr,
          orElse: () => MeasurementSystem.metric,
        );
      }

      final themeStr = prefs.getString(AppConstants.keyThemeMode);
      if (themeStr != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (t) => t.name == themeStr,
          orElse: () => ThemeMode.light,
        );
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> setDefaultSystem(MeasurementSystem system) async {
    if (_defaultSystem == system) return;
    _defaultSystem = system;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyMeasurementSystem, system.name);
    } catch (e) {
      debugPrint('Error saving unit system preference: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyThemeMode, mode.name);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }
}
