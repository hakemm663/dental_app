part of 'appointment_cubit.dart';

class AppointmentState {
  final List<AppointmentModel> appointments;
  final AppointmentModel? createdAppointment;
  final bool isLoading;
  final bool isCreating;
  final String? errorMessage;

  const AppointmentState({
    required this.appointments,
    this.createdAppointment,
    required this.isLoading,
    required this.isCreating,
    this.errorMessage,
  });

  const AppointmentState.initial()
      : this(
          appointments: const [],
          createdAppointment: null,
          isLoading: false,
          isCreating: false,
        );

  const AppointmentState.loading()
      : this(
          appointments: const [],
          createdAppointment: null,
          isLoading: true,
          isCreating: false,
        );

  const AppointmentState.creating()
      : this(
          appointments: const [],
          createdAppointment: null,
          isLoading: false,
          isCreating: true,
        );

  AppointmentState.success({required List<AppointmentModel> appointments})
      : this(
          appointments: appointments,
          createdAppointment: null,
          isLoading: false,
          isCreating: false,
        );

  AppointmentState.created({required AppointmentModel appointment})
      : this(
          appointments: const [],
          createdAppointment: appointment,
          isLoading: false,
          isCreating: false,
        );

  AppointmentState.error({required String message})
      : this(
          appointments: const [],
          createdAppointment: null,
          isLoading: false,
          isCreating: false,
          errorMessage: message,
        );

  AppointmentState copyWith({
    List<AppointmentModel>? appointments,
    AppointmentModel? createdAppointment,
    bool? isLoading,
    bool? isCreating,
    String? errorMessage,
  }) {
    return AppointmentState(
      appointments: appointments ?? this.appointments,
      createdAppointment: createdAppointment ?? this.createdAppointment,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
