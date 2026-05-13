import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/medical_record_model.dart';
import 'package:docdoc/features/home/data/repos/medical_records_repo.dart';

class GetMedicalRecordsUseCase {
  final MedicalRecordsRepo _repo;

  const GetMedicalRecordsUseCase(this._repo);

  Future<ApiResult<List<MedicalRecordModel>>> call() =>
      _repo.getMedicalRecords();
}
