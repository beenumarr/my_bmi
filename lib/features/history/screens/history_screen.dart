import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../services/history_service.dart';
import '../widgets/history_item_card.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryService historyService;
  final VoidCallback onNavigateToCalculator;

  const HistoryScreen({
    super.key,
    required this.historyService,
    required this.onNavigateToCalculator,
  });

  Future<void> _showClearConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History?'),
        content: const Text(
          'This will permanently remove all previous BMI calculation records stored on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await historyService.clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          AnimatedBuilder(
            animation: historyService,
            builder: (context, _) {
              if (historyService.entries.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: 'Clear history',
                onPressed: () => _showClearConfirmation(context),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: historyService,
          builder: (context, _) {
            final entries = historyService.entries;

            if (entries.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceSubtle
                              : AppColors.softGreen,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : Colors.transparent,
                          ),
                        ),
                        child: Icon(
                          Icons.history_rounded,
                          size: 36,
                          color: isDark ? AppColors.primaryGreenDark : AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No Calculations Yet',
                        style: AppTextStyles.headingMedium.copyWith(
                          color: isDark
                              ? AppColors.darkPrimaryText
                              : AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'When you calculate your BMI, your results will be saved securely offline right here.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        label: 'Calculate Your First BMI',
                        icon: Icons.calculate_rounded,
                        fullWidth: false,
                        onPressed: onNavigateToCalculator,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return HistoryItemCard(
                  key: ValueKey(entry.id),
                  entry: entry,
                  onDelete: () => historyService.deleteEntry(entry.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
