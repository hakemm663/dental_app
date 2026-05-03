import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/user_model.dart';
import 'package:docdoc/features/home/data/repos/appointment_repo.dart';

class GetUserProfileUseCase {
  final AppointmentRepo _repo;

  const GetUserProfileUseCase(this._repo);

  Future<ApiResult<UserModel>> call() async {
    try {
      return Success(await _repo.getUserProfile());
    } catch (error) {
      return Failure(error.toString());
    }
  }
}

class UpdateProfileUseCase {
  final AppointmentRepo _repo;

  const UpdateProfileUseCase(this._repo);

  Future<ApiResult<UserModel>> call(Map<String, dynamic> fields) async {
    try {
      return Success(await _repo.updateProfile(fields));
    } catch (error) {
      return Failure(error.toString());
    }
  }
}
