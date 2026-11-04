import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/food_catalog.dart';
import '../../../domain/entities/food_item_entity.dart';
import '../../controllers/calorie_tracker_controller.dart';
import '../../widgets/food_thumbnail_widget.dart';
import 'add_food_screen.dart';
import 'food_detail_screen.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Curry',
    'Meals',
    'Breakfast',
    'Drinks',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FoodCatalogItem> _getFilteredItems(List<FoodCatalogItem> items) {
    return items.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()));
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _intakeItem(BuildContext context, FoodCatalogItem item) {
    context.read<CalorieTrackerController>().addFood(
          item.name,
          item.calories,
          imagePath: item.imagePath,
          tags: item.tags,
          servingSize: item.servingSize,
        );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Intaken "${item.name}" (+${item.calories} kcal)',
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

    final bgColor = AppColors.background(isDark);
    final cardBg = AppColors.card(isDark);
    final cardBorder = AppColors.border(isDark);
    final textPrimary = AppColors.textPrimary(isDark);
    final textSecondary = AppColors.textSecondary(isDark);
    final chipBg = isDark ? AppColors.elevated(isDark) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Food Items',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
            color: textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Search Input Bar at top: "Search food or dishes..."
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cardBorder, width: 1),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(color: textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search food or dishes...',
                    hintStyle: TextStyle(color: textSecondary, fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: textSecondary, size: 22),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear_rounded, color: textSecondary, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),

            // 2. Horizontal Category Filter Pills: All, Curry, Meals, Breakfast, Drinks
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected
                            ? AppColors.onAccent
                            : textSecondary,
                      ),
                      backgroundColor: chipBg,
                      selectedColor: AppColors.accent,
                      checkmarkColor: AppColors.onAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? AppColors.accent : cardBorder,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 6),

            // 3. Scrollable Food Cards
            Expanded(
              child: Consumer<CalorieTrackerController>(
                builder: (context, controller, _) {
                  final items = _getFilteredItems(controller.availableFoods);

                  if (items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: textSecondary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No food items found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Try a different search term or category.',
                              style: TextStyle(
                                fontSize: 13,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        color: cardBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: cardBorder, width: 1),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => FoodDetailScreen(
                                  item: FoodItemEntity(
                                    id: item.id,
                                    name: item.name,
                                    calories: item.calories,
                                    imagePath: item.imagePath,
                                    servingSize: item.servingSize,
                                    time: DateTime.now(),
                                    tags: item.tags,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Circular Food Thumbnail
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(26),
                                  child: FoodThumbnailWidget(
                                    imagePath: item.imagePath,
                                    width: 52,
                                    height: 52,
                                    borderRadius: 26,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Dish Title & Serving Weight
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.2,
                                          color: textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.servingSize,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Calorie Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.accentDim : const Color(0xFFEFF8DE),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.accent.withValues(alpha: 0.3)
                                          : const Color(0xFFD4EDB0),
                                      width: 1,
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
                                const SizedBox(width: 10),

                                // Circular Lime "+" Quick-Add Button
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _intakeItem(context, item),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.accent.withValues(alpha: 0.3),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.add_rounded,
                                        color: AppColors.onAccent,
                                        size: 20,
                                      ),
                                    ),
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

            // 4. Sticky Bottom Action Button: "+ Add Food Item"
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(
                  top: BorderSide(color: cardBorder, width: 1),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AddFoodScreen()),
                    );
                  },
                  icon: const Icon(Icons.add_rounded, color: AppColors.onAccent, size: 20),
                  label: const Text(
                    'Add Food Item',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                      color: AppColors.onAccent,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
