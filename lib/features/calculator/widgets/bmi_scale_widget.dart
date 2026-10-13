import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/bmi_category.dart';

class BmiScaleWidget extends StatelessWidget {
  final double bmi;
  final BmiCategory category;

  const BmiScaleWidget({
    super.key,
    required this.bmi,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Minimum scale 15.0, Maximum scale 45.0
    const minBmi = 15.0;
    const maxBmi = 45.0;
    final clampedBmi = bmi.clamp(minBmi, maxBmi);
    final positionRatio = (clampedBmi - minBmi) / (maxBmi - minBmi);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        // Clamp marker position so it never overflows left or right edge
        const markerWidth = 46.0;
        final targetLeft = (positionRatio * totalWidth) - (markerWidth / 2);
        final markerLeft = targetLeft.clamp(0.0, totalWidth - markerWidth);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Marker Indicator Pin with Animated Value Badge
            SizedBox(
              height: 38,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: markerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: category.color,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: category.color.withValues(alpha: 0.35),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            bmi.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        CustomPaint(
                          size: const Size(8, 5),
                          painter: _TrianglePainter(color: category.color),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 2),

            // Continuous Segmented Bar with rounded ends
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    // Underweight: 15.0 to 18.5 (span: 3.5)
                    Expanded(
                      flex: 35,
                      child: Container(color: AppColors.bmiUnderweight),
                    ),
                    const SizedBox(width: 1),
                    // Healthy: 18.5 to 25.0 (span: 6.5)
                    Expanded(
                      flex: 65,
                      child: Container(color: AppColors.bmiHealthy),
                    ),
                    const SizedBox(width: 1),
                    // Overweight: 25.0 to 30.0 (span: 5.0)
                    Expanded(
                      flex: 50,
                      child: Container(color: AppColors.bmiOverweight),
                    ),
                    const SizedBox(width: 1),
                    // Obese I: 30.0 to 35.0 (span: 5.0)
                    Expanded(
                      flex: 50,
                      child: Container(color: AppColors.bmiObese1),
                    ),
                    const SizedBox(width: 1),
                    // Obese II: 35.0 to 40.0 (span: 5.0)
                    Expanded(
                      flex: 50,
                      child: Container(color: AppColors.bmiObese2),
                    ),
                    const SizedBox(width: 1),
                    // Obese III: 40.0 to 45.0 (span: 5.0)
                    Expanded(
                      flex: 50,
                      child: Container(color: AppColors.bmiObese3),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Ticks and Range Numbers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '<18.5',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  ),
                ),
                Text(
                  '18.5',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  ),
                ),
                Text(
                  '25.0',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  ),
                ),
                Text(
                  '30.0',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  ),
                ),
                Text(
                  '35.0',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  ),
                ),
                Text(
                  '40.0+',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Category Legend Badges
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _buildLegendItem('Underweight', AppColors.bmiUnderweight, category == BmiCategory.underweight),
                _buildLegendItem('Healthy', AppColors.bmiHealthy, category == BmiCategory.healthyWeight),
                _buildLegendItem('Overweight', AppColors.bmiOverweight, category == BmiCategory.overweight),
                _buildLegendItem('Obese I', AppColors.bmiObese1, category == BmiCategory.obesityClass1),
                _buildLegendItem('Obese II', AppColors.bmiObese2, category == BmiCategory.obesityClass2),
                _buildLegendItem('Obese III', AppColors.bmiObese3, category == BmiCategory.obesityClass3),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isCurrent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isCurrent ? color.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isCurrent ? color : Colors.transparent,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
              color: isCurrent ? color : AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) =>
      oldDelegate.color != color;
}
