import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/food_item_entity.dart';
import '../../controllers/calorie_tracker_controller.dart';
import '../../controllers/user_controller.dart';
import '../../widgets/calorie_gauge_widget.dart';
import '../../widgets/food_thumbnail_widget.dart';
import '../../widgets/intake_food_sheet.dart';
import '../food/food_detail_screen.dart';
import '../food/food_screen.dart';
import '../main_navigation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = AppColors.background(isDark);
    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final textPrimary = AppColors.textPrimary(isDark);
    final textSecondary = AppColors.textSecondary(isDark);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          AppConstants.appTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.4,
            color: textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Deep Black Mode',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 21,
              color: isDark ? AppColors.accent : AppColors.mutedLight,
            ),
            onPressed: () {
              ServiceLocator.themeController.toggleTheme(!isDark);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Personalized Greeting & Date (No date strip)
              Consumer<UserController>(
                builder: (context, userController, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormatter.formatFullDate(DateTime.now()),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Welcome, ${userController.name} 👋',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // 2. Today Calories Semi-Circular Gauge Card
              Consumer2<CalorieTrackerController, UserController>(
                builder: (context, trackerController, userController, _) {
                  return CalorieGaugeWidget(
                    totalCalories: trackerController.totalCalories,
                    dailyGoal: userController.dailyGoal,
                  );
                },
              ),
              const SizedBox(height: 14),

              // 3. 2 Information Cards: Total Calories & Daily Goal
              Consumer2<CalorieTrackerController, UserController>(
                builder: (context, trackerController, userController, _) {
                  return Row(
                    children: [
                      // Card 1: Total Calories (consumed)
                      Expanded(
                        child: _SummaryMetricCard(
                          title: 'Total',
                          subtitle: 'Consumed',
                          value: '${trackerController.totalCalories}',
                          unit: 'kcal',
                          valueColor: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                          icon: Icons.restaurant_rounded,
                          iconColor: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                          iconBgColor: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Card 2: Daily Goal (target)
                      Expanded(
                        child: _SummaryMetricCard(
                          title: 'Daily Goal',
                          subtitle: 'Target',
                          value: '${userController.dailyGoal}',
                          unit: 'kcal',
                          valueColor: AppColors.info,
                          icon: Icons.flag_rounded,
                          iconColor: AppColors.info,
                          iconBgColor: isDark ? const Color(0xFF0F1E38) : const Color(0xFFE0F2FE),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),

              // 4. Meal Breakdown Card with 3 Sub-Cards (Breakfast, Lunch, Dinner)
              Consumer<CalorieTrackerController>(
                builder: (context, trackerController, _) {
                  return Card(
                    elevation: 0,
                    color: cardBg,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: cardBorder, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Meals Breakdown',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                '${trackerController.totalCalories} kcal total',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              // Sub-card 1: Breakfast
                              Expanded(
                                child: _MealSubCard(
                                  title: 'Breakfast',
                                  calories: trackerController.breakfastCalories,
                                  icon: Icons.wb_twilight_rounded,
                                  iconBgColor: isDark ? const Color(0xFF261D10) : const Color(0xFFFEF3C7),
                                  iconColor: const Color(0xFFF59E0B),
                                  isDark: isDark,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Sub-card 2: Lunch
                              Expanded(
                                child: _MealSubCard(
                                  title: 'Lunch',
                                  calories: trackerController.lunchCalories,
                                  icon: Icons.wb_sunny_rounded,
                                  iconBgColor: isDark ? const Color(0xFF1E2B0E) : const Color(0xFFEFF8DE),
                                  iconColor: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                                  isDark: isDark,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Sub-card 3: Dinner
                              Expanded(
                                child: _MealSubCard(
                                  title: 'Dinner',
                                  calories: trackerController.dinnerCalories,
                                  icon: Icons.nightlight_round_rounded,
                                  iconBgColor: isDark ? const Color(0xFF0F1E38) : const Color(0xFFE0F2FE),
                                  iconColor: const Color(0xFF38BDF8),
                                  isDark: isDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),

              // 4. Primary Action Button: Full-width Lime Button "+ Add Food"
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => IntakeFoodSheet.show(context),
                  icon: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.onAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.accent,
                      size: 16,
                    ),
                  ),
                  label: const Text(
                    'Add Food',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                      color: AppColors.onAccent,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    elevation: isDark ? 4 : 1,
                    shadowColor: isDark ? AppColors.accent.withValues(alpha: 0.35) : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Today's Meals Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Meals",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                      color: textPrimary,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final mainNav = context.findAncestorStateOfType<MainNavigationScreenState>();
                      if (mainNav != null) {
                        mainNav.setIndex(1);
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const FoodScreen()),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 6. Today's Meals List or Empty State Card
              Consumer<CalorieTrackerController>(
                builder: (context, trackerController, _) {
                  final meals = trackerController.foodItems;

                  if (meals.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: cardBorder, width: 1),
                      ),
                      child: Column(
                        children: [
                          Lottie.asset(
                            'lib/presentation/assets/Food Choice.json',
                            height: 130,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.restaurant_outlined,
                              size: 36,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'No meals intaken today',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap the "+ Add Food" button above to record your intake.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final item = meals[index];
                      return _buildTodayMealCard(context, item, isDark, trackerController);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayMealCard(
    BuildContext context,
    FoodItemEntity item,
    bool isDark,
    CalorieTrackerController trackerController,
  ) {
    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final textColor = AppColors.textPrimary(isDark);
    final secondaryTextColor = AppColors.textSecondary(isDark);
    final accentCalorieColor = isDark ? AppColors.accent : const Color(0xFF4D7C0F);

    final subtitleText = '${item.mealType} • ${DateFormatter.formatTime(item.time)}';

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
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitleText,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: secondaryTextColor,
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
                color: accentCalorieColor,
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
                trackerController.deleteFood(item.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed "${item.name}" from today'),
                    duration: const Duration(seconds: 2),
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
}
}

class _SummaryMetricCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String unit;
  final Color valueColor;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final bool isDark;

  const _SummaryMetricCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.unit,
    required this.valueColor,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final textSecondary = AppColors.textSecondary(isDark);

    return Card(
      elevation: 0,
      color: cardBg,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: cardBorder, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(isDark),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
  }
}

class _MealSubCard extends StatelessWidget {
  final String title;
  final int calories;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final bool isDark;

  const _MealSubCard({
    required this.title,
    required this.calories,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final subBg = isDark ? AppColors.elevated(isDark) : const Color(0xFFF8FAFC);
    final subBorder = AppColors.border(isDark);
    final textPrimary = AppColors.textPrimary(isDark);
    final textSecondary = AppColors.textSecondary(isDark);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: subBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: subBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '$calories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
              color: textPrimary,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
