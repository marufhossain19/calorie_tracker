import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.name,
    required super.dailyGoal,
    required super.heightCm,
    required super.weightKg,
    required super.isMetric,
    required super.appStartDate,
    required super.isOnboarded,
  });

  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      name: entity.name,
      dailyGoal: entity.dailyGoal,
      heightCm: entity.heightCm,
      weightKg: entity.weightKg,
      isMetric: entity.isMetric,
      appStartDate: entity.appStartDate,
      isOnboarded: entity.isOnboarded,
    );
  }
}

