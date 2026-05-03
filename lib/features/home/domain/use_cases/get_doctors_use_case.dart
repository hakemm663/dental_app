import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/data/repos/doctor_repo.dart';

class GetDoctorsUseCase {
  final DoctorRepo _doctorRepo;

  const GetDoctorsUseCase(this._doctorRepo);

  Future<ApiResult<List<DoctorModel>>> call() async {
    try {
      return Success(await _doctorRepo.getAllDoctors());
    } catch (error) {
      return Failure(error.toString());
    }
  }
}

class FilterDoctorsUseCase {
  final DoctorRepo _doctorRepo;

  const FilterDoctorsUseCase(this._doctorRepo);

  Future<ApiResult<List<DoctorModel>>> call({
    int? cityId,
    int? specializationId,
  }) async {
    try {
      return Success(await _doctorRepo.filterDoctors(
        cityId: cityId,
        specializationId: specializationId,
      ));
    } catch (error) {
      return Failure(error.toString());
    }
  }
}

class SearchDoctorsUseCase {
  final DoctorRepo _doctorRepo;

  const SearchDoctorsUseCase(this._doctorRepo);

  Future<ApiResult<List<DoctorModel>>> call(String name) async {
    try {
      return Success(await _doctorRepo.searchDoctors(name));
    } catch (error) {
      return Failure(error.toString());
    }
  }
}

class GetDoctorDetailsUseCase {
  final DoctorRepo _doctorRepo;

  const GetDoctorDetailsUseCase(this._doctorRepo);

  Future<ApiResult<DoctorModel>> call(int doctorId) async {
    try {
      return Success(await _doctorRepo.getDoctorDetails(doctorId));
    } catch (error) {
      return Failure(error.toString());
    }
  }
}
