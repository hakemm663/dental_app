import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/city_model.dart';
import 'package:docdoc/features/home/data/repos/home_repo.dart';

class GetCitiesByGovernorateUseCase {
  final HomeRepo _homeRepo;

  const GetCitiesByGovernorateUseCase(this._homeRepo);

  Future<ApiResult<List<CityModel>>> call(int governorateId) =>
      _homeRepo.getCitiesByGovernorate(governorateId);
}
