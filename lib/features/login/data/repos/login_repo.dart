import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRepo {
  final SupabaseClient _client;

  const LoginRepo(this._client);

  /// Signs in with Supabase Auth. The SDK persists the session itself.
  /// Returns the authenticated user id on success.
  Future<ApiResult<String>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return Success(response.user!.id);
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
