import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';

class DoctorRepo {
  final ApiService _apiService;

  const DoctorRepo(this._apiService);

  Future<List<DoctorModel>> getAllDoctors() async {
    final response = await _apiService.getAllDoctors();
    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data
        .map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DoctorModel> getDoctorDetails(int id) async {
    final response = await _apiService.getDoctorDetails(id);
    return DoctorModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }

  Future<List<DoctorModel>> filterDoctors({
    int? cityId,
    int? specializationId,
  }) async {
    final response = await _apiService.filterDoctors(
      cityId: cityId,
      specializationId: specializationId,
    );
    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data
        .map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<DoctorModel>> searchDoctors(String name) async {
    final response = await _apiService.searchDoctors(name);
    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data
        .map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
