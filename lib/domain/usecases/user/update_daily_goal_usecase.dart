import '../../repositories/user_repository.dart';

class UpdateDailyGoalUseCase {
  final UserRepository _repository;

  const UpdateDailyGoalUseCase(this._repository);

  void execute(int newGoal) => _repository.updateDailyGoal(newGoal);
}

