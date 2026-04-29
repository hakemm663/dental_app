part of 'home_cubit.dart';

class HomeState {
  final List<GovernorateModel> governorates;
  final List<CityModel> cities;
  final List<SpecializationModel> specializations;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    required this.governorates,
    required this.cities,
    required this.specializations,
    required this.isLoading,
    this.errorMessage,
  });

  const HomeState.initial()
      : this(
          governorates: const [],
          cities: const [],
          specializations: const [],
          isLoading: false,
        );

  const HomeState.loading()
      : this(
          governorates: const [],
          cities: const [],
          specializations: const [],
          isLoading: true,
        );

  HomeState.success({
    required List<GovernorateModel> governorates,
    required List<CityModel> cities,
    required List<SpecializationModel> specializations,
  }) : this(
          governorates: governorates,
          cities: cities,
          specializations: specializations,
          isLoading: false,
        );

  HomeState.citiesLoaded({
    required List<GovernorateModel> governorates,
    required List<CityModel> cities,
    required List<SpecializationModel> specializations,
  }) : this(
          governorates: governorates,
          cities: cities,
          specializations: specializations,
          isLoading: false,
        );

  HomeState.error({required String message})
      : this(
          governorates: const [],
          cities: const [],
          specializations: const [],
          isLoading: false,
          errorMessage: message,
        );

  HomeState copyWith({
    List<GovernorateModel>? governorates,
    List<CityModel>? cities,
    List<SpecializationModel>? specializations,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      governorates: governorates ?? this.governorates,
      cities: cities ?? this.cities,
      specializations: specializations ?? this.specializations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
