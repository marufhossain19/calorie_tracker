import '../../domain/entities/food_item_entity.dart';

class FoodItemModel extends FoodItemEntity {
  const FoodItemModel({
    required super.id,
    required super.name,
    required super.calories,
    super.imagePath,
    required super.time,
    super.tags = const [],
    super.servingSize,
    super.mealType = 'Lunch',
  });

  factory FoodItemModel.fromEntity(FoodItemEntity entity) {
    return FoodItemModel(
      id: entity.id,
      name: entity.name,
      calories: entity.calories,
      imagePath: entity.imagePath,
      time: entity.time,
      tags: entity.tags,
      servingSize: entity.servingSize,
      mealType: entity.mealType,
    );
  }
}
