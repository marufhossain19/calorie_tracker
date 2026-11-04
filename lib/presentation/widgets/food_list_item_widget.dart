import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/food_item_entity.dart';

class FoodListItemWidget extends StatelessWidget {
  final FoodItemEntity item;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const FoodListItemWidget({
    super.key,
    required this.item,
    this.onDelete,
    this.onTap,
  });

  IconData _getFoodIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('salad') || lower.contains('vegetable') || lower.contains('green')) {
      return Icons.eco_rounded;
    } else if (lower.contains('chicken') || lower.contains('meat') || lower.contains('beef') || lower.contains('steak')) {
      return Icons.dinner_dining_rounded;
    } else if (lower.contains('fish') || lower.contains('salmon') || lower.contains('tuna')) {
      return Icons.set_meal_rounded;
    } else if (lower.contains('egg') || lower.contains('breakfast') || lower.contains('toast')) {
      return Icons.egg_rounded;
    } else if (lower.contains('rice') || lower.contains('biriyani') || lower.contains('bowl')) {
      return Icons.rice_bowl_rounded;
    } else if (lower.contains('apple') || lower.contains('banana') || lower.contains('fruit')) {
      return Icons.apple_rounded;
    } else if (lower.contains('coffee') || lower.contains('tea') || lower.contains('drink')) {
      return Icons.local_cafe_rounded;
    }
    return Icons.lunch_dining_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconData = _getFoodIcon(item.name);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Food Avatar Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  iconData,
                  color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              // Food Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormatter.formatTime(item.time),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Calorie Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.accent.withValues(alpha: 0.3) : const Color(0xFFD4EDB0),
                  ),
                ),
                child: Text(
                  '${item.calories} kcal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // Delete Icon
              if (onDelete != null)
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  ),
                  onPressed: onDelete,
                  splashRadius: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
