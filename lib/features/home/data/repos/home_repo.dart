import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/home/data/models/city_model.dart';
import 'package:docdoc/features/home/data/models/governorate_model.dart';
import 'package:docdoc/features/home/data/models/specialization_model.dart';

class HomeRepo {
  final ApiService _apiService;

  const HomeRepo(this._apiService);

  Future<List<GovernorateModel>> getAllGovernorates() async {
    final response = await _apiService.getAllGovernorates();
    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data
        .map((e) => GovernorateModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CityModel>> getAllCities() async {
    final response = await _apiService.getAllCities();
    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data
        .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CityModel>> getCitiesByGovernorate(int governorateId) async {
    final response =
        await _apiService.getCitiesByGovernorate(governorateId);
    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data
        .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<SpecializationModel>> getAllSpecializations() async {
    final response = await _apiService.getAllSpecializations();
    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data
        .map((e) => SpecializationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
