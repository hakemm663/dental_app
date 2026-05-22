import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterRepo {
  final SupabaseClient _client;

  const RegisterRepo(this._client);

  /// Creates a Supabase Auth user. `name`, `phone` and `gender` go into the
  /// user metadata; the `handle_new_user` DB trigger copies them into the
  /// `profiles` row. [passwordConfirmation] is validated by the UI form.
  Future<ApiResult<String>> register({
    required String name,
    required String email,
    required String phone,
    required int gender,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
          'phone': phone,
          'gender': gender == 1 ? 'male' : 'female',
        },
      );
      return Success(response.user!.id);
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
