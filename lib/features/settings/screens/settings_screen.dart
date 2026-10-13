import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../../calculator/models/measurement_system.dart';
import '../../history/services/history_service.dart';
import '../services/settings_service.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsService settingsService;
  final HistoryService historyService;

  const SettingsScreen({
    super.key,
    required this.settingsService,
    required this.historyService,
  });

  Future<void> _confirmClearHistory(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Calculation History?'),
        content: const Text(
          'All previous BMI records will be permanently removed from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await historyService.clearHistory();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('History cleared successfully.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: settingsService,
          builder: (context, _) {
            final defaultSystem = settingsService.defaultSystem;
            final currentTheme = settingsService.themeMode;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                _buildSectionHeader('Preferences', isDark),
                const SizedBox(height: 10),

                // Measurement Unit Preference
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.softGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.straighten_rounded,
                              size: 18,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Default Measurement Unit',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: isDark
                                        ? AppColors.darkPrimaryText
                                        : AppColors.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Used automatically when opening the calculator',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.darkSecondaryText
                                        : AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildUnitChoice(
                              context,
                              title: 'Metric (kg, cm)',
                              isSelected: defaultSystem == MeasurementSystem.metric,
                              onTap: () => settingsService
                                  .setDefaultSystem(MeasurementSystem.metric),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildUnitChoice(
                              context,
                              title: 'Imperial (lbs, ft)',
                              isSelected: defaultSystem == MeasurementSystem.imperial,
                              onTap: () => settingsService
                                  .setDefaultSystem(MeasurementSystem.imperial),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Theme Mode Preference
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.softGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.palette_outlined,
                              size: 18,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Theme Preference',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: isDark
                                        ? AppColors.darkPrimaryText
                                        : AppColors.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'White-first design with dark mode option',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.darkSecondaryText
                                        : AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildThemeChip(
                              label: 'Light',
                              icon: Icons.light_mode_outlined,
                              isSelected: currentTheme == ThemeMode.light,
                              onTap: () =>
                                  settingsService.setThemeMode(ThemeMode.light),
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildThemeChip(
                              label: 'Dark',
                              icon: Icons.dark_mode_outlined,
                              isSelected: currentTheme == ThemeMode.dark,
                              onTap: () =>
                                  settingsService.setThemeMode(ThemeMode.dark),
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildThemeChip(
                              label: 'System',
                              icon: Icons.brightness_auto_outlined,
                              isSelected: currentTheme == ThemeMode.system,
                              onTap: () =>
                                  settingsService.setThemeMode(ThemeMode.system),
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('Data & Storage', isDark),
                const SizedBox(height: 10),

                // Clear History Card
                AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Clear History',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkPrimaryText
                                    : AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Remove all saved BMI calculation records',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.darkSecondaryText
                                    : AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => _confirmClearHistory(context),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                        ),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('About', isDark),
                const SizedBox(height: 10),

                // About MyBMI navigation tile
                AppCard(
                  padding: const EdgeInsets.all(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AboutScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.softGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About MyBMI',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkPrimaryText
                                    : AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Mission, privacy statement, and clinical notice',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.darkSecondaryText
                                    : AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: isDark
                            ? AppColors.darkSecondaryText
                            : AppColors.mutedText,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Footer version info
                Center(
                  child: Column(
                    children: [
                      Text(
                        '${AppConstants.appName} v${AppConstants.appVersion}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.mutedText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Built for privacy · 100% Offline',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
      ),
    );
  }

  Widget _buildUnitChoice(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.darkSurfaceSubtle
                  : AppColors.softGreen.withValues(alpha: 0.6))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryGreen
                : (isDark ? AppColors.darkBorder : AppColors.border),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? (isDark ? AppColors.softGreen : AppColors.darkGreen)
                  : (isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.darkSurfaceSubtle
                  : AppColors.softGreen.withValues(alpha: 0.6))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryGreen
                : (isDark ? AppColors.darkBorder : AppColors.border),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? AppColors.primaryGreen
                  : (isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? AppColors.softGreen : AppColors.darkGreen)
                    : (isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
