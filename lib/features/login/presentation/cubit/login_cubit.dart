import 'package:docdoc/core/helpers/constans.dart';
import 'package:docdoc/core/helpers/shared_pref_helper.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/login/domain/use_cases/login_use_case.dart';
import 'package:docdoc/features/login/presentation/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoading());
    final result = await _loginUseCase(email: email, password: password);
    switch (result) {
      case Success(:final data):
        if (data.token != null) {
          await SharedPrefHelper.setSecuredString(
              SharedPrefKeys.userToken, data.token!);
        }
        if (data.username != null) {
          await SharedPrefHelper.setSecuredString(
              SharedPrefKeys.userName, data.username!);
        }
        await SharedPrefHelper.setSecuredString(
            SharedPrefKeys.userEmail, email);
        emit(LoginSuccess(data));
      case Failure(:final errMsg):
        emit(LoginError(errMsg));
    }
  }
}
