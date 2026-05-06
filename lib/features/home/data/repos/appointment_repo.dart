import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/home/data/models/appointment_model.dart';
import 'package:docdoc/features/home/data/models/user_model.dart';

class AppointmentRepo {
  final ApiService _apiService;

  const AppointmentRepo(this._apiService);

  Future<ApiResult<List<AppointmentModel>>> getAllAppointments() async {
    try {
      final response = await _apiService.getAllAppointments();
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return Success(
        data.map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<AppointmentModel>> storeAppointment({
    required int doctorId,
    required String startTime,
    String? notes,
    String? paymentMethod,
    String? cardBrand,
    double? subtotal,
    double? tax,
    double? total,
    String? appointmentType,
  }) async {
    try {
      final response = await _apiService.storeAppointment(
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
      return Success(
        AppointmentModel.fromJson(
          (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
        ),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UserModel>> getUserProfile() async {
    try {
      final response = await _apiService.getUserProfile();
      return Success(
        UserModel.fromJson(
          (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
        ),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UserModel>> updateProfile(Map<String, dynamic> fields) async {
    try {
      final response = await _apiService.updateProfile(fields);
      return Success(
        UserModel.fromJson(
          (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
        ),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
