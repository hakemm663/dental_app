import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorRepo {
  final SupabaseClient _client;

  const DoctorRepo(this._client);

  /// Doctor row plus the embedded resources `DoctorModel.fromJson` expects.
  static const _doctorSelect =
      '*, '
      'specialization:specializations(id, name), '
      'city:cities(id, name, governorate:governorates(id, name)), '
      'clinic:clinics(address, phone)';

  Future<ApiResult<List<DoctorModel>>> getAllDoctors() async {
    try {
      final data = await _client
          .from('doctors')
          .select(_doctorSelect)
          .order('rating', ascending: false);
      return Success(data.map(DoctorModel.fromJson).toList());
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<DoctorModel>> getDoctorDetails(int id) async {
    try {
      final data = await _client
          .from('doctors')
          .select(_doctorSelect)
          .eq('id', id)
          .single();
      return Success(DoctorModel.fromJson(data));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<DoctorModel>>> filterDoctors({
    int? cityId,
    int? specializationId,
  }) async {
    try {
      var query = _client.from('doctors').select(_doctorSelect);
      if (cityId != null) {
        query = query.eq('city_id', cityId);
      }
      if (specializationId != null) {
        query = query.eq('specialization_id', specializationId);
      }
      final data = await query.order('rating', ascending: false);
      return Success(data.map(DoctorModel.fromJson).toList());
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<DoctorModel>>> searchDoctors(String name) async {
    try {
      final data = await _client
          .from('doctors')
          .select(_doctorSelect)
          .ilike('name', '%$name%')
          .order('rating', ascending: false);
      return Success(data.map(DoctorModel.fromJson).toList());
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
