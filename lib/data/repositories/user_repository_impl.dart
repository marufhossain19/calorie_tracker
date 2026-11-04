import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../models/user_profile_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _dataSource;

  const UserRepositoryImpl(this._dataSource);

  @override
  UserProfileEntity getUserProfile() => _dataSource.getUserProfile();

  @override
  void saveUserProfile(UserProfileEntity profile) {
    _dataSource.saveUserProfile(UserProfileModel.fromEntity(profile));
  }

  @override
  void updateDailyGoal(int newGoal) {
    _dataSource.updateDailyGoal(newGoal);
  }
}

