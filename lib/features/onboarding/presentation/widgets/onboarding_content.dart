import 'package:flutter/material.dart';
import 'package:vedaverse/features/onboarding/domain/entities/on_boarding_item.dart';
import '../../../../app/theme/app_colors.dart';

class OnboardingContent extends StatelessWidget {
  final OnboardingItem item;
  final bool isDarkMode;

  const OnboardingContent({
    super.key,
    required this.item,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : AppColors.textPrimary;
    final secondaryText = isDarkMode ? Colors.white70 : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Icon Container
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [item.color.withAlpha(26), item.color.withAlpha(13)],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: item.color.withAlpha(51),
                      width: 2,
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: item.gradientColors,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: item.color.withAlpha(102),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(item.icon, size: 70, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),

          // Title
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),

          // Description
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: secondaryText,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
