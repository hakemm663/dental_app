import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/domain/use_cases/get_doctors_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  final GetDoctorsUseCase _getDoctorsUseCase;
  final FilterDoctorsUseCase _filterDoctorsUseCase;
  final SearchDoctorsUseCase _searchDoctorsUseCase;

  // Full result cache so rating-only changes don't refetch from network
  List<DoctorModel> _allFetched = [];

  DoctorsCubit(
    this._getDoctorsUseCase,
    this._filterDoctorsUseCase,
    this._searchDoctorsUseCase,
  ) : super(const DoctorsState.initial());

  Future<void> getAllDoctors() async {
    emit(const DoctorsState.loading());
    final result = await _getDoctorsUseCase();
    switch (result) {
      case Success(:final data):
        _allFetched = data;
        emit(DoctorsState.success(doctors: data));
      case Failure(:final errMsg):
        emit(DoctorsState.error(message: errMsg));
    }
  }

  Future<void> filterDoctors({int? cityId, int? specializationId}) async {
    emit(const DoctorsState.loading());
    final result = await _filterDoctorsUseCase(
      cityId: cityId,
      specializationId: specializationId,
    );
    switch (result) {
      case Success(:final data):
        _allFetched = data;
        emit(DoctorsState.success(doctors: data));
      case Failure(:final errMsg):
        emit(DoctorsState.error(message: errMsg));
    }
  }

  Future<void> applyFilters({int? specializationId, double? minRating}) async {
    // Fetch from backend when specialization changes
    if (specializationId != null) {
      emit(const DoctorsState.loading());
      final result = await _filterDoctorsUseCase(
        specializationId: specializationId,
      );
      switch (result) {
        case Success(:final data):
          _allFetched = data;
        case Failure(:final errMsg):
          emit(DoctorsState.error(message: errMsg));
          return;
      }
    } else if (_allFetched.isEmpty) {
      // No specialization filter and cache is empty — fetch all
      emit(const DoctorsState.loading());
      final result = await _getDoctorsUseCase();
      switch (result) {
        case Success(:final data):
          _allFetched = data;
        case Failure(:final errMsg):
          emit(DoctorsState.error(message: errMsg));
          return;
      }
    }

    // Apply rating filter client-side
    final filtered = minRating != null
        ? _allFetched
              .where((d) => d.rating != null && d.rating! >= minRating)
              .toList()
        : _allFetched;

    emit(
      DoctorsState.success(
        doctors: filtered,
        activeSpecializationId: specializationId,
        activeMinRating: minRating,
      ),
    );
  }

  Future<void> clearFilters() async {
    emit(const DoctorsState.loading());
    final result = await _getDoctorsUseCase();
    switch (result) {
      case Success(:final data):
        _allFetched = data;
        emit(DoctorsState.success(doctors: data));
      case Failure(:final errMsg):
        emit(DoctorsState.error(message: errMsg));
    }
  }

  Future<void> searchDoctors(String name) async {
    emit(const DoctorsState.loading());
    final result = await _searchDoctorsUseCase(name);
    switch (result) {
      case Success(:final data):
        emit(DoctorsState.success(doctors: data));
      case Failure(:final errMsg):
        emit(DoctorsState.error(message: errMsg));
    }
  }
}
