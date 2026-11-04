import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_tracker/domain/entities/daily_log_entity.dart';
import 'package:calorie_tracker/domain/entities/food_item_entity.dart';
import 'package:calorie_tracker/domain/repositories/food_repository.dart';
import 'package:calorie_tracker/domain/usecases/food/add_food_item_usecase.dart';
import 'package:calorie_tracker/domain/usecases/food/delete_food_item_usecase.dart';
import 'package:calorie_tracker/domain/usecases/food/get_daily_logs_usecase.dart';
import 'package:calorie_tracker/domain/usecases/food/get_food_items_usecase.dart';
import 'package:calorie_tracker/presentation/controllers/calorie_tracker_controller.dart';

class MockFoodRepository implements FoodRepository {
  final List<FoodItemEntity> items = [];

  @override
  List<FoodItemEntity> getFoodItems() => List.unmodifiable(items);

  @override
  void addFoodItem(FoodItemEntity item) => items.insert(0, item);

  @override
  void deleteFoodItem(String id) => items.removeWhere((item) => item.id == id);

  @override
  void insertFoodItem(int index, FoodItemEntity item) => items.insert(index, item);

  @override
  List<DailyLogEntity> getDailyLogs(DateTime from, DateTime to, int currentGoal) {
    return [
      DailyLogEntity(date: from, totalCalories: 1500, dailyGoal: currentGoal),
    ];
  }
}

void main() {
  late MockFoodRepository repository;
  late GetFoodItemsUseCase getFoodItemsUseCase;
  late AddFoodItemUseCase addFoodItemUseCase;
  late DeleteFoodItemUseCase deleteFoodItemUseCase;
  late GetDailyLogsUseCase getDailyLogsUseCase;
  late CalorieTrackerController controller;

  setUp(() {
    repository = MockFoodRepository();
    getFoodItemsUseCase = GetFoodItemsUseCase(repository);
    addFoodItemUseCase = AddFoodItemUseCase(repository);
    deleteFoodItemUseCase = DeleteFoodItemUseCase(repository);
    getDailyLogsUseCase = GetDailyLogsUseCase(repository);

    controller = CalorieTrackerController(
      getFoodItemsUseCase: getFoodItemsUseCase,
      addFoodItemUseCase: addFoodItemUseCase,
      deleteFoodItemUseCase: deleteFoodItemUseCase,
      getDailyLogsUseCase: getDailyLogsUseCase,
      repository: repository,
      dailyGoal: 2000,
    );
  });

  test('Initial state: empty calories and full 2000 remaining', () {
    expect(controller.foodItems.isEmpty, true);
    expect(controller.totalCalories, 0);
    expect(controller.remainingCalories, 2000);
    expect(controller.isOverGoal, false);
  });

  test('Add food item updates total and remaining calories correctly', () {
    controller.addFood('Chicken Breast', 350);

    expect(controller.foodItems.length, 1);
    expect(controller.foodItems.first.name, 'Chicken Breast');
    expect(controller.totalCalories, 350);
    expect(controller.remainingCalories, 1650);
    expect(controller.progressRatio, 350 / 2000);
  });

  test('Delete food item updates calories and supports restore', () {
    controller.addFood('Salad', 200);
    final itemId = controller.foodItems.first.id;
    final item = controller.foodItems.first;

    controller.deleteFood(itemId);
    expect(controller.foodItems.isEmpty, true);
    expect(controller.totalCalories, 0);
    expect(controller.remainingCalories, 2000);

    controller.restoreFood(0, item);
    expect(controller.foodItems.length, 1);
    expect(controller.totalCalories, 200);
  });
}
