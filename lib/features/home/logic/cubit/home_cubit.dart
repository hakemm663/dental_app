import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/features/home/data/repos/home_repo.dart';
import 'package:docdoc/features/home/data/models/governorate_model.dart';
import 'package:docdoc/features/home/data/models/city_model.dart';
import 'package:docdoc/features/home/data/models/specialization_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(const HomeState.initial());

  Future<void> getHomeData() async {
    emit(const HomeState.loading());
    try {
      final governorates = await _homeRepo.getAllGovernrates();
      final cities = await _homeRepo.getAllCities();
      final specializations = await _homeRepo.getAllSpecializations();

      emit(HomeState.success(
        governorates: governorates,
        cities: cities,
        specializations: specializations,
      ));
    } catch (e) {
      emit(HomeState.error(message: e.toString()));
    }
  }

  Future<void> getCitiesByGovernorate(int governorateId) async {
    try {
      final cities = await _homeRepo.getCitiesByGovernorate(governorateId);
      final currentState = state;
      emit(HomeState.citiesLoaded(
        governorates: currentState.governorates,
        cities: cities,
        specializations: currentState.specializations,
      ));
    } catch (e) {
      emit(HomeState.error(message: e.toString()));
    }
  }
}
