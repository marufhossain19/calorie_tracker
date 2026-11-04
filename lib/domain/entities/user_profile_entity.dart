class UserProfileEntity {
  final String name;
  final int dailyGoal;
  final double heightCm;
  final double weightKg;
  final bool isMetric;
  final DateTime appStartDate;
  final bool isOnboarded;

  const UserProfileEntity({
    required this.name,
    required this.dailyGoal,
    required this.heightCm,
    required this.weightKg,
    required this.isMetric,
    required this.appStartDate,
    required this.isOnboarded,
  });

  UserProfileEntity copyWith({
    String? name,
    int? dailyGoal,
    double? heightCm,
    double? weightKg,
    bool? isMetric,
    DateTime? appStartDate,
    bool? isOnboarded,
  }) {
    return UserProfileEntity(
      name: name ?? this.name,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      isMetric: isMetric ?? this.isMetric,
      appStartDate: appStartDate ?? this.appStartDate,
      isOnboarded: isOnboarded ?? this.isOnboarded,
    );
  }
}

