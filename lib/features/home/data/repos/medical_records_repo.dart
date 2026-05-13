import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/home/data/models/medical_record_model.dart';

class MedicalRecordsRepo {
  final ApiService _apiService;

  const MedicalRecordsRepo(this._apiService);

  Future<ApiResult<List<MedicalRecordModel>>> getMedicalRecords() async {
    try {
      final response = await _apiService.getMedicalRecords();
      final body = response.data;
      final raw = body is Map<String, dynamic>
          ? body['data']
          : body;
      final list = raw is List ? raw : <dynamic>[];
      return Success(
        list
            .map((e) =>
                MedicalRecordModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
