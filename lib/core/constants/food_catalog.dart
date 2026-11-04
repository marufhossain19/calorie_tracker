/// Pre-defined food catalog with verified accurate calories and 1-unit serving sizes
/// for items located in [lib/presentation/assets/].
class FoodCatalogItem {
  final String id;
  final String name;
  final int calories;
  final String servingSize;
  final String imagePath;
  final String category;
  final List<String> tags;

  const FoodCatalogItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.servingSize,
    required this.imagePath,
    required this.category,
    required this.tags,
  });
}

class FoodCatalog {
  FoodCatalog._();

  static const List<FoodCatalogItem> items = [
    FoodCatalogItem(
      id: 'cat_boiled_egg',
      name: 'Boiled Egg',
      calories: 78,
      servingSize: '1 pc (50 g)',
      imagePath: 'lib/presentation/assets/boiled egg.jpg',
      category: 'Breakfast',
      tags: ['High Protein', 'Breakfast', 'Low Carb'],
    ),
    FoodCatalogItem(
      id: 'cat_rice',
      name: 'Rice (Cooked)',
      calories: 260,
      servingSize: '1 cup (200 g)',
      imagePath: 'lib/presentation/assets/rice.jpg',
      category: 'Meals',
      tags: ['Carbohydrates', 'Lunch', 'Dinner'],
    ),
    FoodCatalogItem(
      id: 'cat_beef_curry',
      name: 'Beef Curry',
      calories: 280,
      servingSize: '1 bowl (200 g)',
      imagePath: 'lib/presentation/assets/Beef Curry.jpg',
      category: 'Curry',
      tags: ['High Protein', 'Rich', 'Dinner'],
    ),
    FoodCatalogItem(
      id: 'cat_biriyani',
      name: 'Biriyani',
      calories: 480,
      servingSize: '1 plate (300 g)',
      imagePath: 'lib/presentation/assets/Biriyani.jpg',
      category: 'Meals',
      tags: ['Flavorful', 'Lunch', 'Special'],
    ),
    FoodCatalogItem(
      id: 'cat_chicken_curry',
      name: 'Chicken Curry',
      calories: 240,
      servingSize: '1 bowl (180 g)',
      imagePath: 'lib/presentation/assets/chicken curry.jpg',
      category: 'Curry',
      tags: ['High Protein', 'Lunch', 'Dinner'],
    ),
    FoodCatalogItem(
      id: 'cat_fish_curry',
      name: 'Fish Curry',
      calories: 190,
      servingSize: '1 bowl (150 g)',
      imagePath: 'lib/presentation/assets/fish curry.jpg',
      category: 'Curry',
      tags: ['Lean Protein', 'Omega 3', 'Lunch'],
    ),
    FoodCatalogItem(
      id: 'cat_khichuri',
      name: 'Khichuri',
      calories: 240,
      servingSize: '1 plate (220 g)',
      imagePath: 'lib/presentation/assets/Khichuri.jpg',
      category: 'Meals',
      tags: ['Comfort Food', 'Wholesome', 'Lunch'],
    ),
    FoodCatalogItem(
      id: 'cat_lentil_curry',
      name: 'Lentil Curry (Dal)',
      calories: 135,
      servingSize: '1 bowl (150 g)',
      imagePath: 'lib/presentation/assets/lental curry.jpg',
      category: 'Curry',
      tags: ['Plant Protein', 'High Fiber', 'Daily'],
    ),
    FoodCatalogItem(
      id: 'cat_milk_tea',
      name: 'Milk Tea',
      calories: 95,
      servingSize: '1 cup (150 ml)',
      imagePath: 'lib/presentation/assets/milk tea.jpg',
      category: 'Drinks',
      tags: ['Beverage', 'Morning', 'Tea Time'],
    ),
    FoodCatalogItem(
      id: 'cat_omelet',
      name: 'Omelet',
      calories: 175,
      servingSize: '1 pc (80 g)',
      imagePath: 'lib/presentation/assets/omlet.jpg',
      category: 'Breakfast',
      tags: ['Protein', 'Breakfast', 'Quick'],
    ),
    FoodCatalogItem(
      id: 'cat_raw_tea',
      name: 'Raw Tea (Black Tea)',
      calories: 10,
      servingSize: '1 cup (150 ml)',
      imagePath: 'lib/presentation/assets/raw tea.jpg',
      category: 'Drinks',
      tags: ['Zero Fat', 'Antioxidants', 'Warm'],
    ),
    FoodCatalogItem(
      id: 'cat_salad',
      name: 'Fresh Salad',
      calories: 45,
      servingSize: '1 bowl (150 g)',
      imagePath: 'lib/presentation/assets/salad.jpg',
      category: 'Snacks & Salad',
      tags: ['Fresh', 'Low Calorie', 'Vitamins'],
    ),
    FoodCatalogItem(
      id: 'cat_shrimp_curry',
      name: 'Shrimp Curry',
      calories: 215,
      servingSize: '1 bowl (150 g)',
      imagePath: 'lib/presentation/assets/shrimp curry.jpg',
      category: 'Curry',
      tags: ['Seafood', 'High Protein', 'Dinner'],
    ),
    FoodCatalogItem(
      id: 'cat_smashed_potato',
      name: 'Smashed Potato (Alu Bhorta)',
      calories: 125,
      servingSize: '1 scoop (100 g)',
      imagePath: 'lib/presentation/assets/smashed potato.jpg',
      category: 'Meals',
      tags: ['Comfort Food', 'Traditional', 'Lunch'],
    ),
    FoodCatalogItem(
      id: 'cat_vegetables',
      name: 'Mixed Vegetables',
      calories: 115,
      servingSize: '1 bowl (150 g)',
      imagePath: 'lib/presentation/assets/vegetables.jpg',
      category: 'Meals',
      tags: ['Vitamins', 'Fiber', 'Healthy'],
    ),
  ];
}
