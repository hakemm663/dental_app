part of 'search_cubit.dart';

class SearchState {
  final List<String> recentSearches;
  final List<DoctorModel> results;
  final bool isLoading;
  final String query;
  final int? activeSpecializationId;
  final double? activeMinRating;
  final String? errorMessage;

  const SearchState({
    this.recentSearches = const [],
    this.results = const [],
    this.isLoading = false,
    this.query = '',
    this.activeSpecializationId,
    this.activeMinRating,
    this.errorMessage,
  });

  bool get hasQuery => query.isNotEmpty;
  bool get hasResults => results.isNotEmpty;

  const SearchState.initial()
      : recentSearches = const [],
        results = const [],
        isLoading = false,
        query = '',
        activeSpecializationId = null,
        activeMinRating = null,
        errorMessage = null;

  SearchState copyWith({
    List<String>? recentSearches,
    List<DoctorModel>? results,
    bool? isLoading,
    String? query,
    int? activeSpecializationId,
    double? activeMinRating,
    String? errorMessage,
    bool clearError = false,
    bool clearSpecialization = false,
    bool clearRating = false,
  }) {
    return SearchState(
      recentSearches: recentSearches ?? this.recentSearches,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      activeSpecializationId: clearSpecialization
          ? null
          : (activeSpecializationId ?? this.activeSpecializationId),
      activeMinRating: clearRating
          ? null
          : (activeMinRating ?? this.activeMinRating),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
