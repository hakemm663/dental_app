import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/login/data/repos/login_repo.dart';

class LoginUseCase {
  final LoginRepo _loginRepo;

  const LoginUseCase(this._loginRepo);

  Future<ApiResult<String>> call({
    required String email,
    required String password,
  }) =>
      _loginRepo.login(email: email, password: password);
}
