import 'package:flutter/foundation.dart';
import '../../core/utils/bmi_calculator.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/user/get_user_profile_usecase.dart';
import '../../domain/usecases/user/save_user_profile_usecase.dart';
import '../../domain/usecases/user/update_daily_goal_usecase.dart';

class UserController extends ChangeNotifier {
  final GetUserProfileUseCase getUserProfileUseCase;
  final SaveUserProfileUseCase saveUserProfileUseCase;
  final UpdateDailyGoalUseCase updateDailyGoalUseCase;

  late UserProfileEntity _profile;

  UserController({
    required this.getUserProfileUseCase,
    required this.saveUserProfileUseCase,
    required this.updateDailyGoalUseCase,
  }) {
    _profile = getUserProfileUseCase.execute();
  }

  UserProfileEntity get profile => _profile;
  String get name => _profile.name;
  int get dailyGoal => _profile.dailyGoal;
  double get heightCm => _profile.heightCm;
  double get weightKg => _profile.weightKg;
  bool get isMetric => _profile.isMetric;
  DateTime get appStartDate => _profile.appStartDate;
  bool get isOnboarded => _profile.isOnboarded;

  double get bmi => BmiCalculator.calculate(
        heightCm: _profile.heightCm,
        weightKg: _profile.weightKg,
      );

  BmiCategory get bmiCategory => BmiCalculator.getCategory(bmi);

  void completeOnboarding({required String name, required int dailyGoal}) {
    _profile = _profile.copyWith(
      name: name.trim().isEmpty ? 'User' : name.trim(),
      dailyGoal: dailyGoal <= 0 ? 2000 : dailyGoal,
      isOnboarded: true,
      appStartDate: DateTime.now().subtract(const Duration(days: 30)),
    );
    saveUserProfileUseCase.execute(_profile);
    notifyListeners();
  }

  void updateName(String newName) {
    _profile = _profile.copyWith(name: newName);
    saveUserProfileUseCase.execute(_profile);
    notifyListeners();
  }

  void updateDailyGoal(int newGoal) {
    if (newGoal <= 0) return;
    _profile = _profile.copyWith(dailyGoal: newGoal);
    updateDailyGoalUseCase.execute(newGoal);
    notifyListeners();
  }

  void updateHeightCm(double heightCm) {
    _profile = _profile.copyWith(heightCm: heightCm);
    saveUserProfileUseCase.execute(_profile);
    notifyListeners();
  }

  void updateWeightKg(double weightKg) {
    _profile = _profile.copyWith(weightKg: weightKg);
    saveUserProfileUseCase.execute(_profile);
    notifyListeners();
  }

  void toggleMetric(bool isMetric) {
    _profile = _profile.copyWith(isMetric: isMetric);
    saveUserProfileUseCase.execute(_profile);
    notifyListeners();
  }
}

