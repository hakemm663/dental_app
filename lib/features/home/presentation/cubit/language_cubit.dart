import 'package:docdoc/features/home/domain/use_cases/settings_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final GetLanguageCodeUseCase _getUseCase;
  final SetLanguageCodeUseCase _setUseCase;

  LanguageCubit(this._getUseCase, this._setUseCase)
      : super(const LanguageState.initial());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final code = await _getUseCase();
    emit(state.copyWith(code: code, isLoading: false));
  }

  Future<void> setLanguage(String code) async {
    emit(state.copyWith(code: code));
    await _setUseCase(code);
  }
}
