import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/appointment_model.dart';
import 'package:docdoc/features/home/domain/use_cases/appointment_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final GetAppointmentsUseCase _getAppointmentsUseCase;
  final StoreAppointmentUseCase _storeAppointmentUseCase;

  AppointmentCubit(this._getAppointmentsUseCase, this._storeAppointmentUseCase)
      : super(const AppointmentState.initial());

  Future<void> getAllAppointments() async {
    emit(const AppointmentState.loading());
    final result = await _getAppointmentsUseCase();
    switch (result) {
      case Success(:final data):
        emit(AppointmentState.success(appointments: data));
      case Failure(:final errMsg):
        emit(AppointmentState.error(message: errMsg));
    }
  }

  Future<void> storeAppointment({
    required int doctorId,
    required String startTime,
    String? notes,
  }) async {
    emit(const AppointmentState.creating());
    final result = await _storeAppointmentUseCase(
      doctorId: doctorId,
      startTime: startTime,
      notes: notes,
    );
    switch (result) {
      case Success(:final data):
        emit(AppointmentState.created(appointment: data));
        await getAllAppointments();
      case Failure(:final errMsg):
        emit(AppointmentState.error(message: errMsg));
    }
  }
}
