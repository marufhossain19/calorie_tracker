import '../entities/user_profile_entity.dart';

abstract class UserRepository {
  UserProfileEntity getUserProfile();
  void saveUserProfile(UserProfileEntity profile);
  void updateDailyGoal(int newGoal);
}

