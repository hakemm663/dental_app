part of 'doctors_cubit.dart';

class DoctorsState {
  final List<DoctorModel> doctors;
  final bool isLoading;
  final String? errorMessage;

  const DoctorsState({
    required this.doctors,
    required this.isLoading,
    this.errorMessage,
  });

  const DoctorsState.initial()
      : this(
          doctors: const [],
          isLoading: false,
        );

  const DoctorsState.loading()
      : this(
          doctors: const [],
          isLoading: true,
        );

  DoctorsState.success({required List<DoctorModel> doctors})
      : this(
          doctors: doctors,
          isLoading: false,
        );

  DoctorsState.error({required String message})
      : this(
          doctors: const [],
          isLoading: false,
          errorMessage: message,
        );

  DoctorsState copyWith({
    List<DoctorModel>? doctors,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DoctorsState(
      doctors: doctors ?? this.doctors,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
