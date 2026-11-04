import '../../entities/daily_log_entity.dart';
import '../../repositories/food_repository.dart';

class GetDailyLogsUseCase {
  final FoodRepository _repository;

  const GetDailyLogsUseCase(this._repository);

  List<DailyLogEntity> execute(DateTime from, DateTime to, int currentGoal) {
    return _repository.getDailyLogs(from, to, currentGoal);
  }
}

