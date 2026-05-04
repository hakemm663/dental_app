part of 'doctors_cubit.dart';

class DoctorsState {
  final List<DoctorModel> doctors;
  final bool isLoading;
  final String? errorMessage;
  final int? activeSpecializationId;
  final double? activeMinRating;

  const DoctorsState({
    required this.doctors,
    required this.isLoading,
    this.errorMessage,
    this.activeSpecializationId,
    this.activeMinRating,
  });

  const DoctorsState.initial()
      : this(doctors: const [], isLoading: false);

  const DoctorsState.loading()
      : this(doctors: const [], isLoading: true);

  DoctorsState.success({
    required List<DoctorModel> doctors,
    int? activeSpecializationId,
    double? activeMinRating,
  }) : this(
          doctors: doctors,
          isLoading: false,
          activeSpecializationId: activeSpecializationId,
          activeMinRating: activeMinRating,
        );

  DoctorsState.error({required String message})
      : this(doctors: const [], isLoading: false, errorMessage: message);
}
