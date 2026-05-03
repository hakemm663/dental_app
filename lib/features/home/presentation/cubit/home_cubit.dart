import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/city_model.dart';
import 'package:docdoc/features/home/data/models/governorate_model.dart';
import 'package:docdoc/features/home/data/models/specialization_model.dart';
import 'package:docdoc/features/home/domain/use_cases/get_cities_by_governorate_use_case.dart';
import 'package:docdoc/features/home/domain/use_cases/get_home_data_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;
  final GetCitiesByGovernorateUseCase _getCitiesByGovernorateUseCase;

  HomeCubit(this._getHomeDataUseCase, this._getCitiesByGovernorateUseCase)
      : super(const HomeState.initial());

  Future<void> loadHomeData() async {
    emit(const HomeState.loading());
    final result = await _getHomeDataUseCase();
    switch (result) {
      case Success(:final data):
        emit(HomeState.success(
          governorates: data.governorates,
          cities: data.cities,
          specializations: data.specializations,
        ));
      case Failure(:final errMsg):
        emit(HomeState.error(message: errMsg));
    }
  }

  Future<void> loadCitiesByGovernorate(int governorateId) async {
    final result = await _getCitiesByGovernorateUseCase(governorateId);
    switch (result) {
      case Success(:final data):
        emit(HomeState.citiesLoaded(
          governorates: state.governorates,
          cities: data,
          specializations: state.specializations,
        ));
      case Failure(:final errMsg):
        emit(HomeState.error(message: errMsg));
    }
  }
}
