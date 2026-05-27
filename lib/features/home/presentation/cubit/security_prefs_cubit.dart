import 'package:docdoc/features/home/domain/use_cases/settings_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'security_prefs_state.dart';

class SecurityPrefsCubit extends Cubit<SecurityPrefsState> {
  final GetSecurityPrefsUseCase _getUseCase;
  final SetSecurityPrefUseCase _setUseCase;

  SecurityPrefsCubit(this._getUseCase, this._setUseCase)
    : super(const SecurityPrefsState.initial());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final prefs = await _getUseCase();
    emit(
      state.copyWith(
        rememberPassword: prefs['rememberPassword'],
        faceId: prefs['faceId'],
        pin: prefs['pin'],
        isLoading: false,
      ),
    );
  }

  Future<void> toggle(String key, bool value) async {
    emit(switch (key) {
      'rememberPassword' => state.copyWith(rememberPassword: value),
      'faceId' => state.copyWith(faceId: value),
      'pin' => state.copyWith(pin: value),
      _ => state,
    });
    await _setUseCase(key, value);
  }
}
