import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'features/history/services/history_service.dart';
import 'features/settings/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // Initialize offline services
  final settingsService = SettingsService();
  final historyService = HistoryService();

  await Future.wait([
    settingsService.init(),
    historyService.init(),
  ]);

  runApp(
    MyBmiApp(
      settingsService: settingsService,
      historyService: historyService,
    ),
  );
}
