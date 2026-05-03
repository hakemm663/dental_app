import 'package:docdoc/features/login/data/models/login_response.dart';

sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  final LoginResponse loginResponse;
  const LoginSuccess(this.loginResponse);
}

final class LoginError extends LoginState {
  final String errMsg;
  const LoginError(this.errMsg);
}
