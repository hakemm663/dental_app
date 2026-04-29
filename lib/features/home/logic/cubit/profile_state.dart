part of 'profile_cubit.dart';

class ProfileState {
  final UserModel? user;
  final bool isLoading;
  final bool isUpdating;
  final String? errorMessage;

  const ProfileState({
    this.user,
    required this.isLoading,
    required this.isUpdating,
    this.errorMessage,
  });

  const ProfileState.initial()
      : this(
          user: null,
          isLoading: false,
          isUpdating: false,
        );

  const ProfileState.loading()
      : this(
          user: null,
          isLoading: true,
          isUpdating: false,
        );

  const ProfileState.updating()
      : this(
          user: null,
          isLoading: false,
          isUpdating: true,
        );

  ProfileState.success({required UserModel user})
      : this(
          user: user,
          isLoading: false,
          isUpdating: false,
        );

  ProfileState.error({required String message})
      : this(
          user: null,
          isLoading: false,
          isUpdating: false,
          errorMessage: message,
        );
}
