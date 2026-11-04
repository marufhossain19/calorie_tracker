import '../../domain/entities/daily_log_entity.dart';
import '../../domain/entities/food_item_entity.dart';
import '../../domain/repositories/food_repository.dart';
import '../datasources/food_local_data_source.dart';
import '../models/food_item_model.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FoodLocalDataSource _dataSource;

  const FoodRepositoryImpl(this._dataSource);

  @override
  List<FoodItemEntity> getFoodItems() {
    return _dataSource.getFoodItems();
  }

  @override
  void addFoodItem(FoodItemEntity item) {
    _dataSource.addFoodItem(FoodItemModel.fromEntity(item));
  }

  @override
  void deleteFoodItem(String id) {
    _dataSource.deleteFoodItem(id);
  }

  @override
  void insertFoodItem(int index, FoodItemEntity item) {
    _dataSource.insertFoodItem(index, FoodItemModel.fromEntity(item));
  }

  @override
  List<DailyLogEntity> getDailyLogs(DateTime from, DateTime to, int currentGoal) {
    return _dataSource.getDailyLogs(from, to, currentGoal);
  }
}
