import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/appointment_model.dart';
import 'package:docdoc/features/home/data/repos/appointment_repo.dart';

class GetAppointmentsUseCase {
  final AppointmentRepo _repo;

  const GetAppointmentsUseCase(this._repo);

  Future<ApiResult<List<AppointmentModel>>> call() async {
    try {
      return Success(await _repo.getAllAppointments());
    } catch (error) {
      return Failure(error.toString());
    }
  }
}

class StoreAppointmentUseCase {
  final AppointmentRepo _repo;

  const StoreAppointmentUseCase(this._repo);

  Future<ApiResult<AppointmentModel>> call({
    required int doctorId,
    String? notes,
  }) async {
    try {
      return Success(await _repo.storeAppointment(
        doctorId: doctorId,
        notes: notes,
      ));
    } catch (error) {
      return Failure(error.toString());
    }
  }
}
