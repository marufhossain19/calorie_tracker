import '../entities/daily_log_entity.dart';
import '../entities/food_item_entity.dart';

abstract class FoodRepository {
  List<FoodItemEntity> getFoodItems();
  void addFoodItem(FoodItemEntity item);
  void deleteFoodItem(String id);
  void insertFoodItem(int index, FoodItemEntity item);
  List<DailyLogEntity> getDailyLogs(DateTime from, DateTime to, int currentGoal);
}
