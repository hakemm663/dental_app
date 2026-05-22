import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/medical_record_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicalRecordsRepo {
  final SupabaseClient _client;

  const MedicalRecordsRepo(this._client);

  /// Medical records are RLS-scoped to the signed-in user.
  Future<ApiResult<List<MedicalRecordModel>>> getMedicalRecords() async {
    try {
      final data = await _client
          .from('medical_records')
          .select()
          .order('record_date', ascending: false);
      return Success(
        data.map((e) => MedicalRecordModel.fromJson(e)).toList(),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
