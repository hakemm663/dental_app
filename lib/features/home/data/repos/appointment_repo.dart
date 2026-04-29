import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/home/data/models/appointment_model.dart';
import 'package:docdoc/features/home/data/models/user_model.dart';

class AppointmentRepo {
  final ApiService _apiService;

  AppointmentRepo(this._apiService);

  Future<List<AppointmentModel>> getAllAppointments() async {
    try {
      final response = await _apiService.getAllAppointments();
      final data = response['data'] as List;
      return data
          .map((item) => AppointmentModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<AppointmentModel> createAppointment({
    required int doctorId,
    required String startTime,
    String? notes,
  }) async {
    try {
      final response = await _apiService.createAppointment({
        'doctor_id': doctorId,
        'start_time': startTime,
        'notes': ?notes,
      });
      return AppointmentModel.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      final response = await _apiService.getUserProfile();
      return UserModel.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? phone,
    int? gender,
    String? password,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (email != null) body['email'] = email;
      if (phone != null) body['phone'] = phone;
      if (gender != null) body['gender'] = gender;
      if (password != null) body['password'] = password;

      final response = await _apiService.updateProfile(body);
      return UserModel.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
