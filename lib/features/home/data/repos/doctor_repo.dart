import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';

class DoctorRepo {
  final ApiService _apiService;

  const DoctorRepo(this._apiService);

  Future<ApiResult<List<DoctorModel>>> getAllDoctors() async {
    try {
      final response = await _apiService.getAllDoctors();
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return Success(
        data.map((e) => DoctorModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<DoctorModel>> getDoctorDetails(int id) async {
    try {
      final response = await _apiService.getDoctorDetails(id);
      return Success(
        DoctorModel.fromJson(
          (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
        ),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<DoctorModel>>> filterDoctors({
    int? cityId,
    int? specializationId,
  }) async {
    try {
      final response = await _apiService.filterDoctors(
        cityId: cityId,
        specializationId: specializationId,
      );
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return Success(
        data.map((e) => DoctorModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<DoctorModel>>> searchDoctors(String name) async {
    try {
      final response = await _apiService.searchDoctors(name);
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return Success(
        data.map((e) => DoctorModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
