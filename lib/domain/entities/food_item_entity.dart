class FoodItemEntity {
  final String id;
  final String name;
  final int calories;
  final String? imagePath;
  final DateTime time;
  final List<String> tags;
  final String? servingSize;
  final String mealType;

  const FoodItemEntity({
    required this.id,
    required this.name,
    required this.calories,
    this.imagePath,
    required this.time,
    this.tags = const [],
    this.servingSize,
    this.mealType = 'Lunch',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
