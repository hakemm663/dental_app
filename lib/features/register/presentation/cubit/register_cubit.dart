import 'package:docdoc/core/helpers/constans.dart';
import 'package:docdoc/core/helpers/shared_pref_helper.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/login/data/models/login_response.dart';
import 'package:docdoc/features/register/domain/use_cases/register_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit(this._registerUseCase) : super(RegisterInitial());

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required int gender,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(RegisterLoading());
    final ApiResult<LoginResponse> result = await _registerUseCase(
      name: name,
      email: email,
      phone: phone,
      gender: gender,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
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
        emit(RegisterSuccess());
      case Failure(:final errMsg):
        emit(RegisterError(errMsg));
    }
  }
}
