import '../../repositories/food_repository.dart';

class DeleteFoodItemUseCase {
  final FoodRepository _repository;

  const DeleteFoodItemUseCase(this._repository);

  void execute(String id) {
    _repository.deleteFoodItem(id);
  }
}
