class DailyLogEntity {
  final DateTime date;
  final int totalCalories;
  final int dailyGoal;

  const DailyLogEntity({
    required this.date,
    required this.totalCalories,
    required this.dailyGoal,
  });

  bool get isGoalMet => totalCalories >= dailyGoal;
  double get completionRatio => dailyGoal > 0 ? (totalCalories / dailyGoal).clamp(0.0, 1.0) : 0.0;
}

