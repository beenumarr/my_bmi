import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/calculator/screens/calculator_screen.dart';
import 'features/history/screens/history_screen.dart';
import 'features/history/services/history_service.dart';
import 'features/learn/screens/learn_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/settings/services/settings_service.dart';

class MyBmiApp extends StatefulWidget {
  final SettingsService settingsService;
  final HistoryService historyService;

  const MyBmiApp({
    super.key,
    required this.settingsService,
    required this.historyService,
  });

  @override
  State<MyBmiApp> createState() => _MyBmiAppState();
}

class _MyBmiAppState extends State<MyBmiApp> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          settingsService: widget.settingsService,
          historyService: widget.historyService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.settingsService,
      builder: (context, _) {
        return MaterialApp(
          title: 'MyBMI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: widget.settingsService.themeMode,
          home: Builder(
            builder: (innerContext) {
              final pages = [
                CalculatorScreen(
                  historyService: widget.historyService,
                  initialSystem: widget.settingsService.defaultSystem,
                  onOpenSettings: () => _navigateToSettings(innerContext),
                ),
                HistoryScreen(
                  historyService: widget.historyService,
                  onNavigateToCalculator: () => _onTabSelected(0),
                ),
                const LearnScreen(),
              ];

              return Scaffold(
                body: IndexedStack(
                  index: _currentIndex,
                  children: pages,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: _onTabSelected,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calculate_outlined),
                      activeIcon: Icon(Icons.calculate_rounded),
                      label: 'Calculator',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.history_rounded),
                      activeIcon: Icon(Icons.history_toggle_off_rounded),
                      label: 'History',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu_book_outlined),
                      activeIcon: Icon(Icons.menu_book_rounded),
                      label: 'Learn',
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
