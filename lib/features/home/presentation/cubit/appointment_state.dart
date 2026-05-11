part of 'appointment_cubit.dart';

class AppointmentState {
  final List<AppointmentModel> appointments;
  final AppointmentModel? createdAppointment;
  final AppointmentModel? rescheduledAppointment;
  final bool isLoading;
  final bool isCreating;
  final bool isCancelling;
  final bool isRescheduling;
  final int? cancelledAppointmentId;
  final String? errorMessage;

  const AppointmentState({
    required this.appointments,
    this.createdAppointment,
    this.rescheduledAppointment,
    required this.isLoading,
    required this.isCreating,
    this.isCancelling = false,
    this.isRescheduling = false,
    this.cancelledAppointmentId,
    this.errorMessage,
  });

  const AppointmentState.initial()
      : this(
          appointments: const [],
          isLoading: false,
          isCreating: false,
        );

  const AppointmentState.loading()
      : this(
          appointments: const [],
          isLoading: true,
          isCreating: false,
        );

  const AppointmentState.creating()
      : this(
          appointments: const [],
          isLoading: false,
          isCreating: true,
        );

  const AppointmentState.cancelling()
      : this(
          appointments: const [],
          isLoading: false,
          isCreating: false,
          isCancelling: true,
        );

  const AppointmentState.rescheduling()
      : this(
          appointments: const [],
          isLoading: false,
          isCreating: false,
          isRescheduling: true,
        );

  AppointmentState.success({required List<AppointmentModel> appointments})
      : this(
          appointments: appointments,
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

  AppointmentState.cancelled({required int appointmentId})
      : this(
          appointments: const [],
          isLoading: false,
          isCreating: false,
          cancelledAppointmentId: appointmentId,
        );

  AppointmentState.rescheduled({required AppointmentModel appointment})
      : this(
          appointments: const [],
          rescheduledAppointment: appointment,
          isLoading: false,
          isCreating: false,
        );

  AppointmentState.error({required String message})
      : this(
          appointments: const [],
          isLoading: false,
          isCreating: false,
          errorMessage: message,
        );

  AppointmentState copyWith({
    List<AppointmentModel>? appointments,
    AppointmentModel? createdAppointment,
    AppointmentModel? rescheduledAppointment,
    bool? isLoading,
    bool? isCreating,
    bool? isCancelling,
    bool? isRescheduling,
    int? cancelledAppointmentId,
    String? errorMessage,
  }) {
    return AppointmentState(
      appointments: appointments ?? this.appointments,
      createdAppointment: createdAppointment ?? this.createdAppointment,
      rescheduledAppointment: rescheduledAppointment ?? this.rescheduledAppointment,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isCancelling: isCancelling ?? this.isCancelling,
      isRescheduling: isRescheduling ?? this.isRescheduling,
      cancelledAppointmentId: cancelledAppointmentId ?? this.cancelledAppointmentId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
