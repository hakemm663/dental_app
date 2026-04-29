import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';

class DoctorRepo {
  final ApiService _apiService;

  DoctorRepo(this._apiService);

  Future<List<DoctorModel>> getAllDoctors() async {
    try {
      final response = await _apiService.getAllDoctors();
      final data = response['data'] as List;
      return data.map((item) => DoctorModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<DoctorModel> getDoctorDetails(int doctorId) async {
    try {
      final response = await _apiService.getDoctorDetails(doctorId);
      return DoctorModel.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DoctorModel>> filterDoctors({
    int? cityId,
    int? specializationId,
  }) async {
    try {
      final response = await _apiService.filterDoctors(cityId, specializationId);
      final data = response['data'] as List;
      return data.map((item) => DoctorModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DoctorModel>> searchDoctors(String name) async {
    try {
      final response = await _apiService.searchDoctors(name);
      final data = response['data'] as List;
      return data.map((item) => DoctorModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
