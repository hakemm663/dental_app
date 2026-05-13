import 'package:docdoc/core/helpers/constans.dart';
import 'package:docdoc/core/helpers/shared_pref_helper.dart';

class SettingsRepo {
  // ── Notification prefs ────────────────────────────────────────────────────

  Future<Map<String, bool>> getNotificationPrefs() async {
    return {
      'push': await _getBoolWithDefault(SharedPrefKeys.notifPush, true),
      'sound': await _getBoolWithDefault(SharedPrefKeys.notifSound, true),
      'vibrate': await _getBoolWithDefault(SharedPrefKeys.notifVibrate, true),
      'appUpdates':
          await _getBoolWithDefault(SharedPrefKeys.notifAppUpdates, true),
      'specialOffers':
          await _getBoolWithDefault(SharedPrefKeys.notifSpecialOffers, false),
    };
  }

  Future<void> setNotificationPref(String key, bool value) {
    final prefKey = switch (key) {
      'push' => SharedPrefKeys.notifPush,
      'sound' => SharedPrefKeys.notifSound,
      'vibrate' => SharedPrefKeys.notifVibrate,
      'appUpdates' => SharedPrefKeys.notifAppUpdates,
      'specialOffers' => SharedPrefKeys.notifSpecialOffers,
      _ => key,
    };
    return SharedPrefHelper.setData(prefKey, value);
  }

  // ── Security prefs ────────────────────────────────────────────────────────

  Future<Map<String, bool>> getSecurityPrefs() async {
    return {
      'rememberPassword':
          await _getBoolWithDefault(SharedPrefKeys.secRememberPassword, false),
      'faceId': await _getBoolWithDefault(SharedPrefKeys.secFaceId, false),
      'pin': await _getBoolWithDefault(SharedPrefKeys.secPin, false),
    };
  }

  Future<void> setSecurityPref(String key, bool value) {
    final prefKey = switch (key) {
      'rememberPassword' => SharedPrefKeys.secRememberPassword,
      'faceId' => SharedPrefKeys.secFaceId,
      'pin' => SharedPrefKeys.secPin,
      _ => key,
    };
    return SharedPrefHelper.setData(prefKey, value);
  }

  // ── Language ──────────────────────────────────────────────────────────────

  Future<String> getLanguageCode() =>
      SharedPrefHelper.getString(SharedPrefKeys.languageCode).then(
        (v) => v.isEmpty ? 'en' : v,
      );

  Future<void> setLanguageCode(String code) =>
      SharedPrefHelper.setData(SharedPrefKeys.languageCode, code);

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<bool> _getBoolWithDefault(String key, bool defaultValue) async {
    final stored = await SharedPrefHelper.getBoolOrNull(key);
    return stored ?? defaultValue;
  }
}
