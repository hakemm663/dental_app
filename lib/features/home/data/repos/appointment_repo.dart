import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/home/data/models/appointment_model.dart';
import 'package:docdoc/features/home/data/models/user_model.dart';

class AppointmentRepo {
  final ApiService _apiService;

  const AppointmentRepo(this._apiService);

  Future<List<AppointmentModel>> getAllAppointments() async {
    final response = await _apiService.getAllAppointments();
    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data
        .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AppointmentModel> storeAppointment({
    required int doctorId,
    required String startTime,
    String? notes,
  }) async {
    final response = await _apiService.storeAppointment(
      doctorId: doctorId,
      startTime: startTime,
      notes: notes,
    );
    return AppointmentModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }

  Future<UserModel> getUserProfile() async {
    final response = await _apiService.getUserProfile();
    return UserModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }

  Future<UserModel> updateProfile(Map<String, dynamic> fields) async {
    final response = await _apiService.updateProfile(fields);
    return UserModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }
}
