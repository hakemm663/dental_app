part of 'doctor_details_cubit.dart';

class DoctorDetailsState {
  final DoctorModel? doctor;
  final bool isLoading;
  final String? errorMessage;

  const DoctorDetailsState({
    this.doctor,
    required this.isLoading,
    this.errorMessage,
  });

  const DoctorDetailsState.initial() : this(doctor: null, isLoading: false);

  const DoctorDetailsState.loading() : this(doctor: null, isLoading: true);

  DoctorDetailsState.success({required DoctorModel doctor})
    : this(doctor: doctor, isLoading: false);

  DoctorDetailsState.error({required String message})
    : this(doctor: null, isLoading: false, errorMessage: message);
}
