import '../models/user_profile_model.dart';

abstract class UserLocalDataSource {
  UserProfileModel getUserProfile();
  void saveUserProfile(UserProfileModel profile);
  void updateDailyGoal(int newGoal);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  // Initial profile: clean start from zero with isOnboarded = false
  UserProfileModel _profile = UserProfileModel(
    name: '',
    dailyGoal: 2000,
    heightCm: 168.0, // 5 ft 6 in default
    weightKg: 65.0,  // 65.0 kg default
    isMetric: true,
    appStartDate: DateTime.now(),
    isOnboarded: false, // Starts false so new users see onboarding flow
  );

  @override
  UserProfileModel getUserProfile() => _profile;

  @override
  void saveUserProfile(UserProfileModel profile) {
    _profile = profile;
  }

  @override
  void updateDailyGoal(int newGoal) {
    _profile = UserProfileModel(
      name: _profile.name,
      dailyGoal: newGoal,
      heightCm: _profile.heightCm,
      weightKg: _profile.weightKg,
      isMetric: _profile.isMetric,
      appStartDate: _profile.appStartDate,
      isOnboarded: _profile.isOnboarded,
    );
  }
}
