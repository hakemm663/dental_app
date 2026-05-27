part of 'security_prefs_cubit.dart';

class SecurityPrefsState {
  final bool rememberPassword;
  final bool faceId;
  final bool pin;
  final bool isLoading;

  const SecurityPrefsState({
    required this.rememberPassword,
    required this.faceId,
    required this.pin,
    required this.isLoading,
  });

  const SecurityPrefsState.initial()
    : this(
        rememberPassword: false,
        faceId: false,
        pin: false,
        isLoading: false,
      );

  SecurityPrefsState copyWith({
    bool? rememberPassword,
    bool? faceId,
    bool? pin,
    bool? isLoading,
  }) {
    return SecurityPrefsState(
      rememberPassword: rememberPassword ?? this.rememberPassword,
      faceId: faceId ?? this.faceId,
      pin: pin ?? this.pin,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
