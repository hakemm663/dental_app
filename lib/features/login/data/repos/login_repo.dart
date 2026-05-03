import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/login/data/models/login_response.dart';

class LoginRepo {
  final ApiService _apiService;

  const LoginRepo(this._apiService);

  Future<ApiResult<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );
      return Success(LoginResponse.fromJson(response.data as Map<String, dynamic>));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
