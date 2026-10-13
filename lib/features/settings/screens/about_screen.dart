import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About MyBMI'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              // Brand Mark
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.balance_rounded,
                  size: 46,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppConstants.appName,
                style: AppTextStyles.displayMedium.copyWith(
                  color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Version ${AppConstants.appVersion}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A clean, modern, and scientifically responsible health utility.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: 28),

              // Purpose Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.flag_outlined,
                          size: 20,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Our Mission',
                          style: AppTextStyles.headingSmall.copyWith(
                            color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'MyBMI was built to help everyday individuals understand their Body Mass Index through an approachable, calm, and private experience. We focus on simplicity, scientific accuracy, and responsible health information without body shaming or invasive tracking.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Privacy & Offline First Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 20,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Privacy & Offline By Design',
                          style: AppTextStyles.headingSmall.copyWith(
                            color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildBulletPoint(
                      title: '100% Offline Storage',
                      body: 'Your inputs and history never leave this device. No servers, no cloud storage, and no network dependencies.',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint(
                      title: 'Zero Tracking or Analytics',
                      body: 'No telemetry, advertising SDKs, device identifiers, or tracking scripts are bundled.',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint(
                      title: 'No Account Required',
                      body: 'Instant access without registration, passwords, or personal data submission.',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Medical Transparency Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.medical_information_outlined,
                          size: 20,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Scientific Notice',
                          style: AppTextStyles.headingSmall.copyWith(
                            color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'MyBMI is an educational screening tool and does not provide clinical diagnoses, personalized medical prescriptions, or health advice. This app is not certified or approved by medical bodies as a clinical diagnostic instrument. Always seek the advice of your physician with questions concerning a medical condition.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint({
    required String title,
    required String body,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 6, color: AppColors.primaryGreen),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
