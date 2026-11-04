import '../../entities/user_profile_entity.dart';
import '../../repositories/user_repository.dart';

class SaveUserProfileUseCase {
  final UserRepository _repository;

  const SaveUserProfileUseCase(this._repository);

  void execute(UserProfileEntity profile) => _repository.saveUserProfile(profile);
}

