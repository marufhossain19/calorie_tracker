import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class WeekDayStripWidget extends StatelessWidget {
  const WeekDayStripWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final date = startOfWeek.add(Duration(days: index));
        final bool isToday = date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isToday ? AppColors.primaryButton : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isToday
                ? Border.all(color: AppColors.primaryBorder, width: 1.5)
                : Border.all(
                    color: isDark ? AppColors.borderDark : Colors.grey.shade200,
                    width: 1,
                  ),
          ),
          child: Column(
            children: [
              Text(
                dayLabels[index],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isToday
                      ? AppColors.textPrimaryLight
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                  color: isToday
                      ? AppColors.textPrimaryLight
                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
