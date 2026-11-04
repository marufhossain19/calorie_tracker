import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CalorieSummaryCards extends StatelessWidget {
  final int totalCalories;
  final int dailyGoal;

  const CalorieSummaryCards({
    super.key,
    required this.totalCalories,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    final int remaining = dailyGoal - totalCalories;
    final bool isOverGoal = remaining < 0;

    return Row(
      children: [
        // Card 1: Total Calories Consumed
        Expanded(
          child: _MetricCard(
            title: 'Total Calories',
            subtitle: 'Consumed',
            value: '$totalCalories',
            unit: 'kcal',
            icon: Icons.restaurant_rounded,
            themeColor: AppColors.primary,
            bgColor: AppColors.primaryLight,
          ),
        ),
        const SizedBox(width: 10),
        // Card 2: Daily Goal Target (2,000 kcal)
        Expanded(
          child: _MetricCard(
            title: 'Daily Goal',
            subtitle: '2,000 kcal',
            value: '$dailyGoal',
            unit: 'kcal',
            icon: Icons.flag_rounded,
            themeColor: AppColors.secondary,
            bgColor: AppColors.secondaryLight,
          ),
        ),
        const SizedBox(width: 10),
        // Card 3: Remaining Calories
        Expanded(
          child: _MetricCard(
            title: 'Remaining Calories',
            subtitle: isOverGoal ? 'Over Limit' : 'Left Today',
            value: isOverGoal ? '+${-remaining}' : '$remaining',
            unit: 'kcal',
            icon: isOverGoal
                ? Icons.warning_amber_rounded
                : Icons.bolt_rounded,
            themeColor: isOverGoal ? AppColors.error : AppColors.success,
            bgColor: isOverGoal ? AppColors.errorLight : AppColors.successLight,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String unit;
  final IconData icon;
  final Color themeColor;
  final Color bgColor;

  const _MetricCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.unit,
    required this.icon,
    required this.themeColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.borderLight, width: 1),
      ),
      color: AppColors.cardLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: themeColor, size: 18),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryLight,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: themeColor,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Text(
                    'kcal',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
