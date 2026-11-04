import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/food_item_entity.dart';
import '../../controllers/calorie_tracker_controller.dart';
import '../../controllers/user_controller.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItemEntity item;

  const FoodDetailScreen({super.key, required this.item});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  bool _isFavorite = false;

  Widget _buildHeroImage() {
    final imagePath = widget.item.imagePath;

    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('lib/') || imagePath.startsWith('assets/')) {
        return Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          cacheWidth: 800,
        );
      }
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF1B2810),
      child: const Center(
        child: Icon(
          Icons.restaurant_rounded,
          size: 80,
          color: AppColors.accent,
        ),
      ),
    );
  }

  void _logMeal(BuildContext context) {
    final mealType = CalorieTrackerController.determineCurrentMealType();
    context.read<CalorieTrackerController>().addFood(
          widget.item.name,
          widget.item.calories,
          imagePath: widget.item.imagePath,
          tags: widget.item.tags,
          servingSize: widget.item.servingSize,
          mealType: mealType,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Added to $mealType: "${widget.item.name}" (+${widget.item.calories} kcal)',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userController = context.watch<UserController>();
    final dailyGoal = userController.dailyGoal;
    final double targetRatio = dailyGoal > 0 ? (widget.item.calories / dailyGoal).clamp(0.0, 1.0) : 0.0;
    final int targetPercent = (targetRatio * 100).round();

    final bgColor = AppColors.background(isDark);
    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final textPrimary = AppColors.textPrimary(isDark);
    final textSecondary = AppColors.textSecondary(isDark);
    final elevatedBg = AppColors.elevated(isDark);

    final tags = widget.item.tags.isNotEmpty
        ? widget.item.tags
        : ['Healthy', 'Nutritious', 'Fresh'];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with floating back and favorite buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Floating glassmorphic Back button
                  _GlassButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.of(context).pop(),
                    isDark: isDark,
                  ),
                  Text(
                    'Dish Details',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  // Floating glassmorphic Favorite button
                  _GlassButton(
                    icon: _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    iconColor: _isFavorite ? AppColors.error : textPrimary,
                    onTap: () {
                      setState(() => _isFavorite = !_isFavorite);
                    },
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  children: [
                    // 1. Full Hero Dish Image Container (Full width, rounded card)
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: cardBorder,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _buildHeroImage(),
                    ),
                    const SizedBox(height: 16),

                    // 2. Calorie Tab below the image (not overlapping)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF10141B).withValues(alpha: 0.95)
                            : Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: isDark ? AppColors.accent.withValues(alpha: 0.3) : cardBorder,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Circular Progress Ring (% of daily target)
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: targetRatio,
                                  strokeWidth: 3.5,
                                  backgroundColor: isDark
                                      ? const Color(0xFF1E242B)
                                      : const Color(0xFFE2E8F0),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.accent,
                                  ),
                                ),
                                Text(
                                  '$targetPercent%',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${widget.item.calories} kcal',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                'of $dailyGoal kcal goal',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const SizedBox(height: 24),

                    // 3. Dish Title & Inline Metadata
                    Text(
                      widget.item.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Inline Metadata with icons: 🔥 78 kcal  |  🕒 1:51 AM  |  1 serving
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cardBorder, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            size: 16,
                            color: isDark ? AppColors.accent : const Color(0xFF4D7C0F),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.item.calories} kcal',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('|', style: TextStyle(color: cardBorder, fontSize: 13)),
                          ),
                          Icon(Icons.access_time_rounded, size: 15, color: textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            DateFormatter.formatTime(widget.item.time),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: textSecondary,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('|', style: TextStyle(color: cardBorder, fontSize: 13)),
                          ),
                          Icon(Icons.restaurant_rounded, size: 15, color: textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            widget.item.servingSize ?? '1 serving',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. Tags & Attributes
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tags & Attributes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // Primary Attribute Pill with Signature Lime-to-Teal Gradient Fill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD9F99D), Color(0xFF5EEAD4)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF5EEAD4).withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.eco_rounded, size: 14, color: Color(0xFF062E22)),
                              const SizedBox(width: 6),
                              Text(
                                tags.first,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF062E22),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Secondary subtle surface pills
                        ...tags.skip(1).map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: elevatedBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: cardBorder, width: 1),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textSecondary,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom CTA button: "Add to intake meal"
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => _logMeal(context),
                  icon: const Icon(Icons.add_rounded, color: AppColors.onAccent, size: 22),
                  label: const Text(
                    'Add to intake meal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                      color: AppColors.onAccent,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    elevation: isDark ? 4 : 0,
                    shadowColor: isDark ? AppColors.accent.withValues(alpha: 0.35) : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final Color? iconColor;

  const _GlassButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        ),
      ),
    );
  }
}
