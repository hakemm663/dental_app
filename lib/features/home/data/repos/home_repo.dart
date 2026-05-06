import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/home/data/models/city_model.dart';
import 'package:docdoc/features/home/data/models/governorate_model.dart';
import 'package:docdoc/features/home/data/models/specialization_model.dart';

class HomeRepo {
  final ApiService _apiService;

  const HomeRepo(this._apiService);

  Future<ApiResult<List<GovernorateModel>>> getAllGovernorates() async {
    try {
      final response = await _apiService.getAllGovernorates();
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return Success(
        data.map((e) => GovernorateModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<CityModel>>> getAllCities() async {
    try {
      final response = await _apiService.getAllCities();
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return Success(
        data.map((e) => CityModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<CityModel>>> getCitiesByGovernorate(int governorateId) async {
    try {
      final response = await _apiService.getCitiesByGovernorate(governorateId);
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return Success(
        data.map((e) => CityModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<SpecializationModel>>> getAllSpecializations() async {
    try {
      final response = await _apiService.getAllSpecializations();
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return Success(
        data.map((e) => SpecializationModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
