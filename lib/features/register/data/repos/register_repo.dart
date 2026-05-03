import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/login/data/models/login_response.dart';

class RegisterRepo {
  final ApiService _apiService;

  const RegisterRepo(this._apiService);

  Future<ApiResult<LoginResponse>> register({
    required String name,
    required String email,
    required String phone,
    required int gender,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiService.register(
        name: name,
        email: email,
        phone: phone,
        gender: gender,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return Success(
          LoginResponse.fromJson(response.data as Map<String, dynamic>));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
