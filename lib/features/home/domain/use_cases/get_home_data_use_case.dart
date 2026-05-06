import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/city_model.dart';
import 'package:docdoc/features/home/data/models/governorate_model.dart';
import 'package:docdoc/features/home/data/models/specialization_model.dart';
import 'package:docdoc/features/home/data/repos/home_repo.dart';

class HomeData {
  final List<GovernorateModel> governorates;
  final List<CityModel> cities;
  final List<SpecializationModel> specializations;

  const HomeData({
    required this.governorates,
    required this.cities,
    required this.specializations,
  });
}

class GetHomeDataUseCase {
  final HomeRepo _homeRepo;

  const GetHomeDataUseCase(this._homeRepo);

  Future<ApiResult<HomeData>> call() async {
    final govResult = await _homeRepo.getAllGovernorates();
    if (govResult case Failure(:final errMsg)) return Failure(errMsg);

    final cityResult = await _homeRepo.getAllCities();
    if (cityResult case Failure(:final errMsg)) return Failure(errMsg);

    final specResult = await _homeRepo.getAllSpecializations();
    if (specResult case Failure(:final errMsg)) return Failure(errMsg);

    return Success(HomeData(
      governorates: (govResult as Success<List<GovernorateModel>>).data,
      cities: (cityResult as Success<List<CityModel>>).data,
      specializations: (specResult as Success<List<SpecializationModel>>).data,
    ));
  }
}
