import '../../domain/entities/daily_log_entity.dart';
import '../models/food_item_model.dart';

abstract class FoodLocalDataSource {
  List<FoodItemModel> getFoodItems();
  void addFoodItem(FoodItemModel item);
  void deleteFoodItem(String id);
  void insertFoodItem(int index, FoodItemModel item);
  List<DailyLogEntity> getDailyLogs(DateTime from, DateTime to, int currentGoal);
}

class FoodLocalDataSourceImpl implements FoodLocalDataSource {
  // Empty list: starts clean from zero (no static demo items)
  final List<FoodItemModel> _items = [];

  // In-memory historical daily calories: starts clean from zero
  final Map<String, int> _historicalDayCalories = {};

  FoodLocalDataSourceImpl();

  String _dateKey(DateTime dt) => '${dt.year}-${dt.month}-${dt.day}';

  @override
  List<FoodItemModel> getFoodItems() => List.unmodifiable(_items);

  @override
  void addFoodItem(FoodItemModel item) {
    _items.insert(0, item);
  }

  @override
  void deleteFoodItem(String id) {
    _items.removeWhere((element) => element.id == id);
  }

  @override
  void insertFoodItem(int index, FoodItemModel item) {
    _items.insert(index, item);
  }

  @override
  List<DailyLogEntity> getDailyLogs(DateTime from, DateTime to, int currentGoal) {
    final List<DailyLogEntity> logs = [];
    DateTime cursor = DateTime(from.year, from.month, from.day);
    final endDate = DateTime(to.year, to.month, to.day);
    final todayKey = _dateKey(DateTime.now());
    final int todayCalories = _items.fold(0, (sum, item) => sum + item.calories);

    while (!cursor.isAfter(endDate)) {
      final key = _dateKey(cursor);
      int cals = 0;
      if (key == todayKey) {
        cals = todayCalories;
      } else if (_historicalDayCalories.containsKey(key)) {
        cals = _historicalDayCalories[key]!;
      }

      logs.add(
        DailyLogEntity(
          date: cursor,
          totalCalories: cals,
          dailyGoal: currentGoal,
        ),
      );

      cursor = cursor.add(const Duration(days: 1));
    }

    return List.unmodifiable(logs);
  }
}
