import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/login/data/models/login_response.dart';
import 'package:docdoc/features/register/data/repos/register_repo.dart';

class RegisterUseCase {
  final RegisterRepo _registerRepo;

  const RegisterUseCase(this._registerRepo);

  Future<ApiResult<LoginResponse>> call({
    required String name,
    required String email,
    required String phone,
    required int gender,
    required String password,
    required String passwordConfirmation,
  }) =>
      _registerRepo.register(
        name: name,
        email: email,
        phone: phone,
        gender: gender,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
}
