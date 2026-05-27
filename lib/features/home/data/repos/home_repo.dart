import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/city_model.dart';
import 'package:docdoc/features/home/data/models/governorate_model.dart';
import 'package:docdoc/features/home/data/models/specialization_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRepo {
  final SupabaseClient _client;

  const HomeRepo(this._client);

  static const _cityWithGovernorate = '*, governorate:governorates(id, name)';

  Future<ApiResult<List<GovernorateModel>>> getAllGovernorates() async {
    try {
      final data = await _client.from('governorates').select().order('name');
      return Success(data.map(GovernorateModel.fromJson).toList());
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<CityModel>>> getAllCities() async {
    try {
      final data = await _client
          .from('cities')
          .select(_cityWithGovernorate)
          .order('name');
      return Success(data.map(CityModel.fromJson).toList());
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<CityModel>>> getCitiesByGovernorate(
    int governorateId,
  ) async {
    try {
      final data = await _client
          .from('cities')
          .select(_cityWithGovernorate)
          .eq('governorate_id', governorateId)
          .order('name');
      return Success(data.map(CityModel.fromJson).toList());
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<SpecializationModel>>> getAllSpecializations() async {
    try {
      final data = await _client.from('specializations').select().order('name');
      return Success(data.map(SpecializationModel.fromJson).toList());
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
