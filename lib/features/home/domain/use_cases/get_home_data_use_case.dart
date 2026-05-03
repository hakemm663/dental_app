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
    try {
      final results = await Future.wait([
        _homeRepo.getAllGovernorates(),
        _homeRepo.getAllCities(),
        _homeRepo.getAllSpecializations(),
      ]);
      return Success(HomeData(
        governorates: results[0] as List<GovernorateModel>,
        cities: results[1] as List<CityModel>,
        specializations: results[2] as List<SpecializationModel>,
      ));
    } catch (error) {
      return Failure(error.toString());
    }
  }
}
