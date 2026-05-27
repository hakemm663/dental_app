import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/user_model.dart';
import 'package:docdoc/features/home/data/repos/appointment_repo.dart';

class GetUserProfileUseCase {
  final AppointmentRepo _repo;

  const GetUserProfileUseCase(this._repo);

  Future<ApiResult<UserModel>> call() => _repo.getUserProfile();
}

class UpdateProfileUseCase {
  final AppointmentRepo _repo;

  const UpdateProfileUseCase(this._repo);

  Future<ApiResult<UserModel>> call(Map<String, dynamic> fields) =>
      _repo.updateProfile(fields);
}

class UpdateAvatarUseCase {
  final AppointmentRepo _repo;

  const UpdateAvatarUseCase(this._repo);

  Future<ApiResult<UserModel>> call(String filePath) =>
      _repo.updateAvatar(filePath);
}
