import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/appointment_model.dart';
import 'package:docdoc/features/home/data/models/appointment_type.dart';
import 'package:docdoc/features/home/data/models/payment_method.dart';
import 'package:docdoc/features/home/domain/use_cases/appointment_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final GetAppointmentsUseCase _getAppointmentsUseCase;
  final StoreAppointmentUseCase _storeAppointmentUseCase;
  final CancelAppointmentUseCase _cancelAppointmentUseCase;
  final RescheduleAppointmentUseCase _rescheduleAppointmentUseCase;

  List<AppointmentModel> _cachedAppointments = [];

  AppointmentCubit(
    this._getAppointmentsUseCase,
    this._storeAppointmentUseCase,
    this._cancelAppointmentUseCase,
    this._rescheduleAppointmentUseCase,
  ) : super(const AppointmentState.initial());

  List<AppointmentModel> get cachedAppointments => _cachedAppointments;

  Future<void> getAllAppointments() async {
    emit(const AppointmentState.loading());
    final result = await _getAppointmentsUseCase();
    switch (result) {
      case Success(:final data):
        _cachedAppointments = data;
        emit(AppointmentState.success(appointments: data));
      case Failure(:final errMsg):
        emit(AppointmentState.error(message: errMsg));
    }
  }

  Future<void> storeAppointment({
    required int doctorId,
    required String startTime,
    required PaymentMethod paymentMethod,
    required AppointmentType appointmentType,
    required double subtotal,
    required double tax,
    String? notes,
  }) async {
    emit(
      AppointmentState(
        appointments: _cachedAppointments,
        isLoading: false,
        isCreating: true,
      ),
    );
    final result = await _storeAppointmentUseCase(
      doctorId: doctorId,
      startTime: startTime,
      notes: notes,
      paymentMethod: paymentMethod.wireKey,
      cardBrand: paymentMethod is CreditCardPayment
          ? paymentMethod.brand.wireKey
          : null,
      subtotal: subtotal,
      tax: tax,
      total: subtotal + tax,
      appointmentType: appointmentType.wireKey,
    );
    switch (result) {
      case Success(:final data):
        emit(AppointmentState.created(appointment: data));
        await getAllAppointments();
      case Failure(:final errMsg):
        emit(AppointmentState.error(message: errMsg));
    }
  }

  Future<void> cancelAppointment(int id) async {
    emit(
      AppointmentState(
        appointments: _cachedAppointments,
        isLoading: false,
        isCreating: false,
        isCancelling: true,
      ),
    );
    final result = await _cancelAppointmentUseCase(id);
    _cachedAppointments = _cachedAppointments
        .map((a) => a.id == id ? a.copyWith(status: 'cancelled') : a)
        .toList();
    switch (result) {
      case Success():
      case Failure():
        emit(
          AppointmentState(
            appointments: _cachedAppointments,
            isLoading: false,
            isCreating: false,
            cancelledAppointmentId: id,
          ),
        );
    }
  }

  Future<void> rescheduleAppointment({
    required int id,
    required String startTime,
    required AppointmentType appointmentType,
  }) async {
    emit(
      AppointmentState(
        appointments: _cachedAppointments,
        isLoading: false,
        isCreating: false,
        isRescheduling: true,
      ),
    );
    final result = await _rescheduleAppointmentUseCase(
      id: id,
      startTime: startTime,
      appointmentType: appointmentType.wireKey,
    );
    switch (result) {
      case Success(:final data):
        _cachedAppointments = _cachedAppointments
            .map((a) => a.id == id ? data : a)
            .toList();
        emit(
          AppointmentState(
            appointments: _cachedAppointments,
            rescheduledAppointment: data,
            isLoading: false,
            isCreating: false,
          ),
        );
      case Failure(:final errMsg):
        final updated = _cachedAppointments
            .where((a) => a.id == id)
            .firstOrNull
            ?.copyWith(
              appointmentTime: startTime,
              appointmentType: appointmentType.wireKey,
            );
        if (updated != null) {
          _cachedAppointments = _cachedAppointments
              .map((a) => a.id == id ? updated : a)
              .toList();
          emit(
            AppointmentState(
              appointments: _cachedAppointments,
              rescheduledAppointment: updated,
              isLoading: false,
              isCreating: false,
            ),
          );
        } else {
          emit(AppointmentState.error(message: errMsg));
        }
    }
  }
}
