import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/features/home/data/repos/appointment_repo.dart';
import 'package:docdoc/features/home/data/models/appointment_model.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepo _appointmentRepo;

  AppointmentCubit(this._appointmentRepo)
      : super(const AppointmentState.initial());

  Future<void> getAllAppointments() async {
    emit(const AppointmentState.loading());
    try {
      final appointments = await _appointmentRepo.getAllAppointments();
      emit(AppointmentState.success(appointments: appointments));
    } catch (e) {
      emit(AppointmentState.error(message: e.toString()));
    }
  }

  Future<void> createAppointment({
    required int doctorId,
    required String startTime,
    String? notes,
  }) async {
    emit(const AppointmentState.creating());
    try {
      final appointment = await _appointmentRepo.createAppointment(
        doctorId: doctorId,
        startTime: startTime,
        notes: notes,
      );
      emit(AppointmentState.created(appointment: appointment));
      // Refresh list
      await getAllAppointments();
    } catch (e) {
      emit(AppointmentState.error(message: e.toString()));
    }
  }
}
