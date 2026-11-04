import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/food_catalog.dart';
import '../controllers/calorie_tracker_controller.dart';
import '../screens/food/add_food_screen.dart';
import 'food_thumbnail_widget.dart';

/// Modal bottom sheet allowing the user to intake food from the catalog of 15 authentic dishes
/// with verified calories and photos from [lib/presentation/assets/].
class IntakeFoodSheet extends StatefulWidget {
  const IntakeFoodSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const IntakeFoodSheet(),
    );
  }

  @override
  State<IntakeFoodSheet> createState() => _IntakeFoodSheetState();
}

class _IntakeFoodSheetState extends State<IntakeFoodSheet> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Curry',
    'Meals',
    'Breakfast',
    'Drinks',
    'Snacks & Salad',
  ];

  List<FoodCatalogItem> _getFilteredItems(List<FoodCatalogItem> items) {
    return items.where((item) {
      final matchesSearch =
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.tags.any(
            (t) => t.toLowerCase().contains(_searchQuery.toLowerCase()),
          );
      final matchesCategory =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _intakeItem(FoodCatalogItem item) {
    final mealType = CalorieTrackerController.determineCurrentMealType();
    context.read<CalorieTrackerController>().addFood(
      item.name,
      item.calories,
      imagePath: item.imagePath,
      tags: item.tags,
      servingSize: item.servingSize,
      mealType: mealType,
    );

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFFB5F52E),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Added to $mealType: "${item.name}" (+${item.calories} kcal)',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sheetBg = AppColors.card(isDark);
    final cardBg = isDark
        ? AppColors.elevated(isDark)
        : AppColors.backgroundLight;
    final borderColor = AppColors.border(isDark);
    final accentColor = isDark ? AppColors.accent : const Color(0xFF4D7C0F);
    final textColor = AppColors.textPrimary(isDark);
    final secondaryTextColor = AppColors.textSecondary(isDark);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // 1. Drag Handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF25292D)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // 2. Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.restaurant_rounded,
                                color: accentColor,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Intake Food',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.3,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Select a food item to intake calories for today',
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: secondaryTextColor,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // 3. Search Box
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search food (e.g. Rice, Boiled Egg, Curry...)',
                    hintStyle: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: accentColor,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xFF1E232B)
                        : const Color(0xFFF1F3F5),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: accentColor, width: 1.5),
                    ),
                  ),
                ),
              ),

              // 4. Category Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = cat),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: isSelected
                              ? (isDark ? Colors.black : Colors.white)
                              : secondaryTextColor,
                        ),
                        backgroundColor: isDark
                            ? const Color(0xFF1E232B)
                            : Colors.grey.shade100,
                        selectedColor: accentColor,
                        checkmarkColor: isDark ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? accentColor : borderColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),

              // 5. Food Items List
              Expanded(
                child: Consumer<CalorieTrackerController>(
                  builder: (context, tracker, _) {
                    final filteredItems = _getFilteredItems(
                      tracker.availableFoods,
                    );

                    if (filteredItems.isEmpty) {
                      return Center(
                        child: Text(
                          'No food found matching "$_searchQuery"',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];

                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          color: cardBg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(color: borderColor, width: 1),
                          ),
                          child: InkWell(
                            onTap: () => _intakeItem(item),
                            borderRadius: BorderRadius.circular(18),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Food Thumbnail
                                  FoodThumbnailWidget(
                                    imagePath: item.imagePath,
                                    width: 56,
                                    height: 56,
                                    borderRadius: 14,
                                  ),
                                  const SizedBox(width: 14),

                                  // Name & Serving
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          item.servingSize,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Calorie Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF1B2810)
                                          : AppColors.primaryLight,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isDark
                                            ? const Color(0xFFB5F52E)
                                                  .withValues(alpha: 0.35)
                                            : AppColors.primaryBorder,
                                      ),
                                    ),
                                    child: Text(
                                      '${item.calories} kcal',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: accentColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // Add/Intake Icon Button
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.accent
                                          : const Color(0xFF4D7C0F),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: isDark
                                          ? AppColors.onAccent
                                          : Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // 6. Custom Food Option at Bottom
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                decoration: BoxDecoration(
                  color: sheetBg,
                  border: Border(top: BorderSide(color: borderColor)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddFoodScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.add_rounded, color: accentColor, size: 20),
                    label: Text(
                      'Add Food Item',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
