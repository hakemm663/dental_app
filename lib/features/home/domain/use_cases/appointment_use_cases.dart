import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/appointment_model.dart';
import 'package:docdoc/features/home/data/repos/appointment_repo.dart';

class GetAppointmentsUseCase {
  final AppointmentRepo _repo;

  const GetAppointmentsUseCase(this._repo);

  Future<ApiResult<List<AppointmentModel>>> call() => _repo.getAllAppointments();
}

class StoreAppointmentUseCase {
  final AppointmentRepo _repo;

  const StoreAppointmentUseCase(this._repo);

  Future<ApiResult<AppointmentModel>> call({
    required int doctorId,
    required String startTime,
    String? notes,
    String? paymentMethod,
    String? cardBrand,
    double? subtotal,
    double? tax,
    double? total,
    String? appointmentType,
  }) =>
      _repo.storeAppointment(
        doctorId: doctorId,
        startTime: startTime,
        notes: notes,
        paymentMethod: paymentMethod,
        cardBrand: cardBrand,
        subtotal: subtotal,
        tax: tax,
        total: total,
        appointmentType: appointmentType,
      );
}

class CancelAppointmentUseCase {
  final AppointmentRepo _repo;

  const CancelAppointmentUseCase(this._repo);

  Future<ApiResult<void>> call(int id) => _repo.cancelAppointment(id);
}

class RescheduleAppointmentUseCase {
  final AppointmentRepo _repo;

  const RescheduleAppointmentUseCase(this._repo);

  Future<ApiResult<AppointmentModel>> call({
    required int id,
    required String startTime,
    String? appointmentType,
  }) =>
      _repo.rescheduleAppointment(
        id: id,
        startTime: startTime,
        appointmentType: appointmentType,
      );
}
