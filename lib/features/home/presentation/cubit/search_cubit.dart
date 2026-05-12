import 'dart:async';

import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/domain/use_cases/get_doctors_use_case.dart';
import 'package:docdoc/features/home/domain/use_cases/recent_searches_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchDoctorsUseCase _searchDoctorsUseCase;
  final GetRecentSearchesUseCase _getRecentSearches;
  final AddRecentSearchUseCase _addRecentSearch;
  final RemoveRecentSearchUseCase _removeRecentSearch;
  final ClearRecentSearchesUseCase _clearRecentSearches;

  Timer? _debounce;
  int _queryId = 0;
  List<DoctorModel> _allFetched = [];

  SearchCubit(
    this._searchDoctorsUseCase,
    this._getRecentSearches,
    this._addRecentSearch,
    this._removeRecentSearch,
    this._clearRecentSearches,
  ) : super(const SearchState.initial());

  Future<void> loadRecentSearches() async {
    final recent = await _getRecentSearches();
    emit(state.copyWith(recentSearches: recent));
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      _allFetched = [];
      emit(state.copyWith(
        query: '',
        results: [],
        isLoading: false,
        clearError: true,
        clearSpecialization: true,
        clearRating: true,
      ));
      return;
    }

    emit(state.copyWith(query: trimmed, isLoading: true, clearError: true));

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _fetchResults(trimmed);
    });
  }

  Future<void> _fetchResults(String query) async {
    final id = ++_queryId;
    final result = await _searchDoctorsUseCase(query);
    // Discard stale responses
    if (id != _queryId) return;

    switch (result) {
      case Success(:final data):
        _allFetched = data;
        await _addRecentSearch(query);
        final recent = await _getRecentSearches();
        final filtered = _applyFilters(
          _allFetched,
          state.activeSpecializationId,
          state.activeMinRating,
        );
        emit(state.copyWith(
          results: filtered,
          recentSearches: recent,
          isLoading: false,
          clearError: true,
        ));
      case Failure(:final errMsg):
        _allFetched = [];
        emit(state.copyWith(
          isLoading: false,
          errorMessage: errMsg,
          results: [],
        ));
    }
  }

  void applyFilters({int? specializationId, double? minRating}) {
    final filtered = _applyFilters(_allFetched, specializationId, minRating);
    emit(state.copyWith(
      results: filtered,
      activeSpecializationId: specializationId,
      activeMinRating: minRating,
      clearSpecialization: specializationId == null,
      clearRating: minRating == null,
    ));
  }

  List<DoctorModel> _applyFilters(
    List<DoctorModel> source,
    int? specializationId,
    double? minRating,
  ) {
    var filtered = source;
    if (specializationId != null) {
      filtered =
          filtered.where((d) => d.specializationId == specializationId).toList();
    }
    if (minRating != null) {
      filtered =
          filtered.where((d) => d.rating != null && d.rating! >= minRating).toList();
    }
    return filtered;
  }

  Future<void> removeRecentSearch(String query) async {
    await _removeRecentSearch(query);
    final recent = await _getRecentSearches();
    emit(state.copyWith(recentSearches: recent));
  }

  Future<void> clearAllRecentSearches() async {
    await _clearRecentSearches();
    emit(state.copyWith(recentSearches: []));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
