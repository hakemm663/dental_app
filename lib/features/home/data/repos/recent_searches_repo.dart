import 'package:docdoc/core/helpers/constans.dart';
import 'package:docdoc/core/helpers/shared_pref_helper.dart';

class RecentSearchesRepo {
  static const int _maxItems = 10;

  Future<List<String>> getAll() =>
      SharedPrefHelper.getStringList(SharedPrefKeys.recentSearches);

  Future<void> add(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final current = await getAll();
    final updated = [
      trimmed,
      ...current.where((q) => q.toLowerCase() != trimmed.toLowerCase()),
    ].take(_maxItems).toList();
    await SharedPrefHelper.setStringList(
      SharedPrefKeys.recentSearches,
      updated,
    );
  }

  Future<void> remove(String query) async {
    final current = await getAll();
    final updated = current
        .where((q) => q.toLowerCase() != query.toLowerCase())
        .toList();
    await SharedPrefHelper.setStringList(
      SharedPrefKeys.recentSearches,
      updated,
    );
  }

  Future<void> clearAll() =>
      SharedPrefHelper.setStringList(SharedPrefKeys.recentSearches, []);
}
