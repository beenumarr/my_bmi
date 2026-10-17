import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_bmi/app.dart';
import 'package:my_bmi/core/constants/app_constants.dart';
import 'package:my_bmi/features/history/services/history_service.dart';
import 'package:my_bmi/features/settings/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('MyBmiApp loads and displays Calculator with navigation tabs',
      (WidgetTester tester) async {
    final settingsService = SettingsService();
    final historyService = HistoryService();
    await settingsService.init();
    await historyService.init();

    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MyBmiApp(
        settingsService: settingsService,
        historyService: historyService,
      ),
    );
    await tester.pumpAndSettle();

    // Verify Brand title and welcome header
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.appTagline), findsOneWidget);
    expect(find.text('Calculate My BMI'), findsOneWidget);

    // Verify Navigation Bar items
    expect(find.text('Calculator'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);

    // Switch to History tab
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('No Calculations Yet'), findsOneWidget);

    // Switch to Learn tab
    await tester.tap(find.text('Learn'));
    await tester.pumpAndSettle();
    expect(find.text('About BMI'), findsOneWidget);
    expect(find.text('1. What is BMI?'), findsOneWidget);
    expect(find.text('2. How is BMI Calculated?'), findsOneWidget);

    // Switch back to Calculator tab
    await tester.tap(find.text('Calculator'));
    await tester.pumpAndSettle();

    // Enter height and weight in metric mode
    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.at(0), '175');
    await tester.enterText(textFields.at(1), '70');

    // Scroll to and tap Calculate button
    final calcButton = find.text('Calculate My BMI');
    await tester.ensureVisible(calcButton);
    await tester.pumpAndSettle();
    await tester.tap(calcButton);
    await tester.pumpAndSettle();

    // Check result is displayed
    expect(find.text('Calculation Result'), findsOneWidget);
    expect(find.text('22.9'), findsWidgets); // Hero + marker
    expect(find.text('Healthy Weight'), findsWidgets);
  });

  testWidgets('Dark mode can be set and updates ThemeData brightness',
      (WidgetTester tester) async {
    final settingsService = SettingsService();
    final historyService = HistoryService();
    await settingsService.init();
    await historyService.init();

    await tester.pumpWidget(
      MyBmiApp(
        settingsService: settingsService,
        historyService: historyService,
      ),
    );
    await tester.pumpAndSettle();

    // Set theme to dark
    await settingsService.setThemeMode(ThemeMode.dark);
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
  });
}
