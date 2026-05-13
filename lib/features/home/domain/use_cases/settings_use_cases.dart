import 'package:docdoc/features/home/data/repos/settings_repo.dart';

class GetNotificationPrefsUseCase {
  final SettingsRepo _repo;

  const GetNotificationPrefsUseCase(this._repo);

  Future<Map<String, bool>> call() => _repo.getNotificationPrefs();
}

class SetNotificationPrefUseCase {
  final SettingsRepo _repo;

  const SetNotificationPrefUseCase(this._repo);

  Future<void> call(String key, bool value) =>
      _repo.setNotificationPref(key, value);
}

class GetSecurityPrefsUseCase {
  final SettingsRepo _repo;

  const GetSecurityPrefsUseCase(this._repo);

  Future<Map<String, bool>> call() => _repo.getSecurityPrefs();
}

class SetSecurityPrefUseCase {
  final SettingsRepo _repo;

  const SetSecurityPrefUseCase(this._repo);

  Future<void> call(String key, bool value) =>
      _repo.setSecurityPref(key, value);
}

class GetLanguageCodeUseCase {
  final SettingsRepo _repo;

  const GetLanguageCodeUseCase(this._repo);

  Future<String> call() => _repo.getLanguageCode();
}

class SetLanguageCodeUseCase {
  final SettingsRepo _repo;

  const SetLanguageCodeUseCase(this._repo);

  Future<void> call(String code) => _repo.setLanguageCode(code);
}
