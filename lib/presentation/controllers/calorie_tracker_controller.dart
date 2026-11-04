import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/food_catalog.dart';
import '../../domain/entities/daily_log_entity.dart';
import '../../domain/entities/food_item_entity.dart';
import '../../domain/usecases/food/add_food_item_usecase.dart';
import '../../domain/usecases/food/delete_food_item_usecase.dart';
import '../../domain/usecases/food/get_daily_logs_usecase.dart';
import '../../domain/usecases/food/get_food_items_usecase.dart';
import '../../domain/repositories/food_repository.dart';

class CalorieTrackerController extends ChangeNotifier {
  final GetFoodItemsUseCase getFoodItemsUseCase;
  final AddFoodItemUseCase addFoodItemUseCase;
  final DeleteFoodItemUseCase deleteFoodItemUseCase;
  final GetDailyLogsUseCase getDailyLogsUseCase;
  final FoodRepository repository;

  int dailyGoal;
  List<FoodItemEntity> _foodItems = [];
  final List<FoodCatalogItem> _availableFoods = List.from(FoodCatalog.items);
  bool _isDisposed = false;

  CalorieTrackerController({
    required this.getFoodItemsUseCase,
    required this.addFoodItemUseCase,
    required this.deleteFoodItemUseCase,
    required this.getDailyLogsUseCase,
    required this.repository,
    this.dailyGoal = AppConstants.defaultDailyGoal,
  }) {
    loadFoodItems();
  }

  List<FoodItemEntity> get foodItems => _foodItems;
  List<FoodCatalogItem> get availableFoods => List.unmodifiable(_availableFoods);
  bool get isDisposed => _isDisposed;

  int get totalCalories =>
      _foodItems.fold(0, (sum, item) => sum + item.calories);

  int get breakfastCalories => _foodItems
      .where((item) => item.mealType.toLowerCase() == 'breakfast')
      .fold(0, (sum, item) => sum + item.calories);

  int get lunchCalories => _foodItems
      .where((item) => item.mealType.toLowerCase() == 'lunch')
      .fold(0, (sum, item) => sum + item.calories);

  int get dinnerCalories => _foodItems
      .where((item) => item.mealType.toLowerCase() == 'dinner')
      .fold(0, (sum, item) => sum + item.calories);

  int get remainingCalories => dailyGoal - totalCalories;

  double get progressRatio =>
      dailyGoal > 0 ? (totalCalories / dailyGoal).clamp(0.0, 1.0) : 0.0;

  bool get isOverGoal => remainingCalories < 0;

  void updateDailyGoal(int newGoal) {
    if (_isDisposed || newGoal <= 0) return;
    dailyGoal = newGoal;
    notifyListeners();
  }

  void loadFoodItems() {
    if (_isDisposed) return;
    _foodItems = getFoodItemsUseCase.execute();
    notifyListeners();
  }

  void addFood(
    String name,
    int calories, {
    String? imagePath,
    List<String> tags = const [],
    String? servingSize,
    String? mealType,
  }) {
    if (_isDisposed) return;
    final determinedMealType = mealType ?? determineCurrentMealType();
    final newItem = FoodItemEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      calories: calories,
      imagePath: imagePath,
      time: DateTime.now(),
      tags: tags.isEmpty ? ['Healthy', 'Nutritious'] : tags,
      servingSize: servingSize,
      mealType: determinedMealType,
    );
    addFoodItemUseCase.execute(newItem);
    _foodItems = getFoodItemsUseCase.execute();
    notifyListeners();
  }

  /// 4 am to 11:59 AM: Breakfast
  /// 12 pm to 5:59 PM (12 to 5 pm): Lunch
  /// 6 pm to 3:59 am: Dinner
  static String determineCurrentMealType([DateTime? dateTime]) {
    final time = dateTime ?? DateTime.now();
    final hour = time.hour;
    if (hour >= 4 && hour < 12) {
      return 'Breakfast';
    } else if (hour >= 12 && hour < 18) {
      return 'Lunch';
    } else {
      return 'Dinner';
    }
  }

  void deleteFood(String id) {
    if (_isDisposed) return;
    deleteFoodItemUseCase.execute(id);
    _foodItems = getFoodItemsUseCase.execute();
    notifyListeners();
  }

  void restoreFood(int index, FoodItemEntity item) {
    if (_isDisposed) return;
    repository.insertFoodItem(index, item);
    _foodItems = getFoodItemsUseCase.execute();
    notifyListeners();
  }

  void addCatalogItem({
    required String name,
    required int calories,
    String? imagePath,
    String servingSize = '1 serving',
    String category = 'Custom',
    List<String> tags = const ['Custom'],
  }) {
    if (_isDisposed) return;
    final item = FoodCatalogItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      calories: calories,
      servingSize: servingSize,
      imagePath: imagePath ?? '',
      category: category,
      tags: tags,
    );
    _availableFoods.insert(0, item);
    notifyListeners();
  }

  void deleteCatalogItem(String id) {
    if (_isDisposed) return;
    _availableFoods.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void restoreCatalogItem(int index, FoodCatalogItem item) {
    if (_isDisposed) return;
    _availableFoods.insert(index, item);
    notifyListeners();
  }

  List<DailyLogEntity> getLogsForRange(DateTime from, DateTime to) {
    return getDailyLogsUseCase.execute(from, to, dailyGoal);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
