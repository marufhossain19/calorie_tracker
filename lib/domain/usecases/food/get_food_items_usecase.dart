import '../../entities/food_item_entity.dart';
import '../../repositories/food_repository.dart';

class GetFoodItemsUseCase {
  final FoodRepository _repository;

  const GetFoodItemsUseCase(this._repository);

  List<FoodItemEntity> execute() {
    return _repository.getFoodItems();
  }
}
