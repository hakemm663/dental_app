part of 'language_cubit.dart';

class LanguageState {
  final String code;
  final bool isLoading;

  const LanguageState({required this.code, required this.isLoading});

  const LanguageState.initial() : this(code: 'en', isLoading: false);

  LanguageState copyWith({String? code, bool? isLoading}) {
    return LanguageState(
      code: code ?? this.code,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
