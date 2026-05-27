import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/data/repos/doctor_repo.dart';

class GetDoctorsUseCase {
  final DoctorRepo _doctorRepo;

  const GetDoctorsUseCase(this._doctorRepo);

  Future<ApiResult<List<DoctorModel>>> call() => _doctorRepo.getAllDoctors();
}

class FilterDoctorsUseCase {
  final DoctorRepo _doctorRepo;

  const FilterDoctorsUseCase(this._doctorRepo);

  Future<ApiResult<List<DoctorModel>>> call({
    int? cityId,
    int? specializationId,
  }) => _doctorRepo.filterDoctors(
    cityId: cityId,
    specializationId: specializationId,
  );
}

class SearchDoctorsUseCase {
  final DoctorRepo _doctorRepo;

  const SearchDoctorsUseCase(this._doctorRepo);

  Future<ApiResult<List<DoctorModel>>> call(String name) =>
      _doctorRepo.searchDoctors(name);
}

class GetDoctorDetailsUseCase {
  final DoctorRepo _doctorRepo;

  const GetDoctorDetailsUseCase(this._doctorRepo);

  Future<ApiResult<DoctorModel>> call(int doctorId) =>
      _doctorRepo.getDoctorDetails(doctorId);
}
