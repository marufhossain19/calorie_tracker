import '../../entities/user_profile_entity.dart';
import '../../repositories/user_repository.dart';

class GetUserProfileUseCase {
  final UserRepository _repository;

  const GetUserProfileUseCase(this._repository);

  UserProfileEntity execute() => _repository.getUserProfile();
}

