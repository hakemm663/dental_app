import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/home/data/models/governorate_model.dart';
import 'package:docdoc/features/home/data/models/city_model.dart';
import 'package:docdoc/features/home/data/models/specialization_model.dart';

class HomeRepo {
  final ApiService _apiService;

  HomeRepo(this._apiService);

  Future<List<GovernorateModel>> getAllGovernrates() async {
    try {
      final response = await _apiService.getAllGovernrates();
      final data = response['data'] as List;
      return data.map((item) => GovernorateModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CityModel>> getAllCities() async {
    try {
      final response = await _apiService.getAllCities();
      final data = response['data'] as List;
      return data.map((item) => CityModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CityModel>> getCitiesByGovernorate(int governorateId) async {
    try {
      final response = await _apiService.getCitiesByGovernorate(governorateId);
      final data = response['data'] as List;
      return data.map((item) => CityModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SpecializationModel>> getAllSpecializations() async {
    try {
      final response = await _apiService.getAllSpecializations();
      final data = response['data'] as List;
      return data.map((item) => SpecializationModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getHomeData() async {
    try {
      final response = await _apiService.getHomeData();
      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
