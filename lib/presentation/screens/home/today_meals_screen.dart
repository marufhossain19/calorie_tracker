import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/food_item_entity.dart';
import '../../controllers/calorie_tracker_controller.dart';
import '../../widgets/food_thumbnail_widget.dart';
import '../../widgets/intake_food_sheet.dart';
import '../food/food_detail_screen.dart';

/// Screen dedicated to displaying, scrolling, and managing all logged meals for today.
class TodayMealsScreen extends StatelessWidget {
  const TodayMealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');

    final bgColor = AppColors.background(isDark);
    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final elevatedBg = AppColors.elevated(isDark);
    final textPrimary = AppColors.textPrimary(isDark);
    final textSecondary = AppColors.textSecondary(isDark);
    final accentColor = isDark ? AppColors.accent : const Color(0xFF4D7C0F);

    return Consumer<CalorieTrackerController>(
      builder: (context, tracker, _) {
        final meals = tracker.foodItems;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              "Today's Meals",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
                color: textPrimary,
              ),
            ),
            actions: [
              if (meals.isNotEmpty)
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.accent.withValues(alpha: 0.3) : cardBorder,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${tracker.totalCalories} kcal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: meals.isEmpty
              ? _buildEmptyState(context, isDark, isTest, textPrimary, textSecondary)
              : _buildMealsList(
                  context,
                  meals,
                  tracker,
                  isDark,
                  cardBg,
                  cardBorder,
                  elevatedBg,
                  textPrimary,
                  textSecondary,
                  accentColor,
                ),
          bottomNavigationBar: meals.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    border: Border(
                      top: BorderSide(color: cardBorder, width: 1),
                    ),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => IntakeFoodSheet.show(context),
                        icon: const Icon(
                          Icons.add_circle_outline_rounded,
                          color: AppColors.onAccent,
                          size: 20,
                        ),
                        label: const Text(
                          'Add Meal to Today',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.2,
                            color: AppColors.onAccent,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.onAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    bool isDark,
    bool isTest,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'lib/presentation/assets/Food Choice.json',
              height: 180,
              fit: BoxFit.contain,
              repeat: !isTest,
              animate: !isTest,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.restaurant_outlined,
                size: 64,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No Meals Logged Today',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have not recorded any meals for today yet. Tap below to select from your food items.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => IntakeFoodSheet.show(context),
              icon: const Icon(
                Icons.add_rounded,
                color: AppColors.onAccent,
                size: 20,
              ),
              label: const Text(
                'Add Food',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onAccent,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsList(
    BuildContext context,
    List<FoodItemEntity> meals,
    CalorieTrackerController tracker,
    bool isDark,
    Color cardBg,
    Color cardBorder,
    Color elevatedBg,
    Color textPrimary,
    Color textSecondary,
    Color accentColor,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Meals Summary Pill Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: elevatedBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cardBorder, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMealTypeSummary('Breakfast', tracker.breakfastCalories, isDark, textPrimary, textSecondary),
                Container(height: 24, width: 1, color: cardBorder),
                _buildMealTypeSummary('Lunch', tracker.lunchCalories, isDark, textPrimary, textSecondary),
                Container(height: 24, width: 1, color: cardBorder),
                _buildMealTypeSummary('Dinner', tracker.dinnerCalories, isDark, textPrimary, textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 18),

          Text(
            'Logged Items (${meals.length})',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final item = meals[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: cardBorder, width: 1),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    leading: FoodThumbnailWidget(
                      imagePath: item.imagePath,
                      width: 48,
                      height: 48,
                      borderRadius: 12,
                    ),
                    title: Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        color: textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      '${item.mealType} • ${DateFormatter.formatTime(item.time)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${item.calories} kcal',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: accentColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            size: 20,
                            color: isDark ? const Color(0xFF64748B) : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            tracker.deleteFood(item.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Removed "${item.name}" from today'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  textColor: AppColors.accent,
                                  onPressed: () => tracker.restoreFood(index, item),
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FoodDetailScreen(item: item),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeSummary(
    String label,
    int calories,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$calories kcal',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
          ),
        ),
      ],
    );
  }
}

