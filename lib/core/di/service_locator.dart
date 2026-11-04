import '../../data/datasources/food_local_data_source.dart';
import '../../data/datasources/user_local_data_source.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/food_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/food/add_food_item_usecase.dart';
import '../../domain/usecases/food/delete_food_item_usecase.dart';
import '../../domain/usecases/food/get_daily_logs_usecase.dart';
import '../../domain/usecases/food/get_food_items_usecase.dart';
import '../../domain/usecases/user/get_user_profile_usecase.dart';
import '../../domain/usecases/user/save_user_profile_usecase.dart';
import '../../domain/usecases/user/update_daily_goal_usecase.dart';
import '../theme/theme_controller.dart';
import '../../presentation/controllers/calorie_tracker_controller.dart';
import '../../presentation/controllers/user_controller.dart';

class ServiceLocator {
  ServiceLocator._();

  static FoodLocalDataSource? _foodDataSource;
  static UserLocalDataSource? _userDataSource;

  static FoodRepository? _foodRepository;
  static UserRepository? _userRepository;

  static GetFoodItemsUseCase? _getFoodItemsUseCase;
  static AddFoodItemUseCase? _addFoodItemUseCase;
  static DeleteFoodItemUseCase? _deleteFoodItemUseCase;
  static GetDailyLogsUseCase? _getDailyLogsUseCase;

  static GetUserProfileUseCase? _getUserProfileUseCase;
  static SaveUserProfileUseCase? _saveUserProfileUseCase;
  static UpdateDailyGoalUseCase? _updateDailyGoalUseCase;

  static ThemeController? _themeController;
  static ThemeController get themeController => _themeController ??= ThemeController();
  static UserController? _userController;
  static CalorieTrackerController? _calorieTrackerController;

  static void init({
    FoodLocalDataSource? customFoodDataSource,
    UserLocalDataSource? customUserDataSource,
  }) {
    _themeController = ThemeController();

    // 1. Data Sources
    _foodDataSource = customFoodDataSource ?? FoodLocalDataSourceImpl();
    _userDataSource = customUserDataSource ?? UserLocalDataSourceImpl();

    // 2. Repositories
    _foodRepository = FoodRepositoryImpl(_foodDataSource!);
    _userRepository = UserRepositoryImpl(_userDataSource!);

    // 3. Use Cases
    _getFoodItemsUseCase = GetFoodItemsUseCase(_foodRepository!);
    _addFoodItemUseCase = AddFoodItemUseCase(_foodRepository!);
    _deleteFoodItemUseCase = DeleteFoodItemUseCase(_foodRepository!);
    _getDailyLogsUseCase = GetDailyLogsUseCase(_foodRepository!);

    _getUserProfileUseCase = GetUserProfileUseCase(_userRepository!);
    _saveUserProfileUseCase = SaveUserProfileUseCase(_userRepository!);
    _updateDailyGoalUseCase = UpdateDailyGoalUseCase(_userRepository!);

    // 4. Controllers
    _userController = UserController(
      getUserProfileUseCase: _getUserProfileUseCase!,
      saveUserProfileUseCase: _saveUserProfileUseCase!,
      updateDailyGoalUseCase: _updateDailyGoalUseCase!,
    );

    _calorieTrackerController = CalorieTrackerController(
      getFoodItemsUseCase: _getFoodItemsUseCase!,
      addFoodItemUseCase: _addFoodItemUseCase!,
      deleteFoodItemUseCase: _deleteFoodItemUseCase!,
      getDailyLogsUseCase: _getDailyLogsUseCase!,
      repository: _foodRepository!,
      dailyGoal: _userController!.dailyGoal,
    );
  }

  static UserController get userController {
    if (_userController == null) init();
    return _userController!;
  }

  static CalorieTrackerController get calorieTrackerController {
    if (_calorieTrackerController == null) init();
    return _calorieTrackerController!;
  }

  static CalorieTrackerController createCalorieTrackerController() {
    if (_foodDataSource == null) init();
    return CalorieTrackerController(
      getFoodItemsUseCase: _getFoodItemsUseCase!,
      addFoodItemUseCase: _addFoodItemUseCase!,
      deleteFoodItemUseCase: _deleteFoodItemUseCase!,
      getDailyLogsUseCase: _getDailyLogsUseCase!,
      repository: _foodRepository!,
      dailyGoal: userController.dailyGoal,
    );
  }
}
