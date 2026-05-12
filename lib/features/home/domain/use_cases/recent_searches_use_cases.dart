import 'package:docdoc/features/home/data/repos/recent_searches_repo.dart';

class GetRecentSearchesUseCase {
  final RecentSearchesRepo _repo;
  const GetRecentSearchesUseCase(this._repo);
  Future<List<String>> call() => _repo.getAll();
}

class AddRecentSearchUseCase {
  final RecentSearchesRepo _repo;
  const AddRecentSearchUseCase(this._repo);
  Future<void> call(String query) => _repo.add(query);
}

class RemoveRecentSearchUseCase {
  final RecentSearchesRepo _repo;
  const RemoveRecentSearchUseCase(this._repo);
  Future<void> call(String query) => _repo.remove(query);
}

class ClearRecentSearchesUseCase {
  final RecentSearchesRepo _repo;
  const ClearRecentSearchesUseCase(this._repo);
  Future<void> call() => _repo.clearAll();
}
