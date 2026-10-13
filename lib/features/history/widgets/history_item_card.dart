import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';
import '../models/history_entry.dart';

class HistoryItemCard extends StatelessWidget {
  final HistoryEntry entry;
  final VoidCallback onDelete;

  const HistoryItemCard({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = entry.category;
    final formattedDate = DateFormat.yMMMd().add_jm().format(entry.timestamp);

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Timestamp & Delete action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: isDark ? AppColors.darkSecondaryText : AppColors.mutedText,
                tooltip: 'Delete entry',
                onPressed: onDelete,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Row 2: BMI Number & Category Chip
          Row(
            children: [
              Text(
                entry.displayedBmi,
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'BMI',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: category.color.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: category.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: category.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Row 3: Height & Weight badges
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildSmallBadge(
                icon: Icons.height_rounded,
                label: entry.heightDisplay,
                isDark: isDark,
              ),
              _buildSmallBadge(
                icon: Icons.monitor_weight_outlined,
                label: entry.weightDisplay,
                isDark: isDark,
              ),
              if (entry.age != null)
                _buildSmallBadge(
                  icon: Icons.cake_outlined,
                  label: '${entry.age} yrs',
                  isDark: isDark,
                ),
              if (entry.sex != null)
                _buildSmallBadge(
                  icon: Icons.person_outline_rounded,
                  label: entry.sex!,
                  isDark: isDark,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallBadge({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceSubtle : AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
