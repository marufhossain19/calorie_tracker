import '../../entities/food_item_entity.dart';
import '../../repositories/food_repository.dart';

class AddFoodItemUseCase {
  final FoodRepository _repository;

  const AddFoodItemUseCase(this._repository);

  void execute(FoodItemEntity item) {
    _repository.addFoodItem(item);
  }
}
