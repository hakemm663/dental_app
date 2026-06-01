/// Build flavors. Selected at compile time via `--dart-define=ENV=<name>`;
/// defaults to [Flavor.dev] when the define is absent.
enum Flavor { dev, staging, prod }

/// Compile-time environment configuration.
///
/// The active flavor is chosen with `--dart-define=ENV=dev|staging|prod`,
/// surfaced via [flavor]. All other keys are read via [String.fromEnvironment]
/// and either come from individual `--dart-define=KEY=value` arguments or an
/// `env/<flavor>.json` file passed through
/// `--dart-define-from-file=env/<flavor>.json`.
///
/// NEVER put server-side secrets here (Supabase service role key, Paymob HMAC,
/// Agora app certificate, Firebase admin JSON). Anything compiled into the
/// binary ships with the app and can be extracted; secrets stay on Firebase
/// Functions / a trusted backend.
class Env {
  Env._();

  // ── Flavor ──────────────────────────────────────────────────────────────

  static const String _value = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  static Flavor get flavor => switch (_value) {
    'prod' || 'production' => Flavor.prod,
    'staging' => Flavor.staging,
    _ => Flavor.dev,
  };

  static bool get isDev => flavor == Flavor.dev;
  static bool get isStaging => flavor == Flavor.staging;
  static bool get isProd => flavor == Flavor.prod;

  /// Human label, surfaced in debug banners / Crashlytics breadcrumbs.
  static String get name => switch (flavor) {
    Flavor.dev => 'dev',
    Flavor.staging => 'staging',
    Flavor.prod => 'prod',
  };

  // ── Legacy VCare base URL (kept until VCare is fully retired) ───────────

  static const String _integrationApiUrl =
      'https://vcare.integration25.com/api/';

  static const String _prodApiUrl = String.fromEnvironment(
    'PROD_API_BASE_URL',
    defaultValue: _integrationApiUrl,
  );

  /// VCare API base URL for the active flavor.
  static String get apiBaseUrl => switch (flavor) {
    Flavor.dev => _integrationApiUrl,
    Flavor.staging => _integrationApiUrl,
    Flavor.prod => _prodApiUrl,
  };

  // ── Supabase ────────────────────────────────────────────────────────────

  /// Supabase project URL.
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xtlynstfzipnfbczsohz.supabase.co',
  );

  /// Publishable (anon) key — RLS-protected, designed to ship in the client.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_8d0ZxhM9IbAW1hrLGJ5eRg_mxIgxXHv',
  );

  // ── Agora (video calls) ─────────────────────────────────────────────────

  /// Agora app ID (public). The app certificate is a server-side secret and
  /// MUST NOT be embedded here — token minting lives on Firebase Functions.
  static const String agoraAppId = String.fromEnvironment('AGORA_APP_ID');

  // ── Google Maps ─────────────────────────────────────────────────────────

  /// Google Maps API key for Android (restrict to package + SHA-1 in console).
  static const String googleMapsApiKeyAndroid = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY_ANDROID',
  );

  /// Google Maps API key for iOS (restrict to bundle ID in console).
  static const String googleMapsApiKeyIos = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY_IOS',
  );

  // ── Firebase ────────────────────────────────────────────────────────────

  /// Firebase project ID — used only for log context. The SDK reads its real
  /// config from `GoogleService-Info.plist` / `google-services.json`.
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );

  // ── Paymob (payments) ───────────────────────────────────────────────────

  /// Paymob public key. The HMAC secret + API key stay on Firebase Functions —
  /// never embed them in the binary.
  static const String paymobPublicKey = String.fromEnvironment(
    'PAYMOB_PUBLIC_KEY',
  );

  // ── Diagnostic ──────────────────────────────────────────────────────────

  /// Redacted summary safe to log on startup — verifies the right env file
  /// was picked at build time without leaking key prefixes.
  static Map<String, String> get summary => {
    'ENV': name,
    'SUPABASE_URL': supabaseUrl.isEmpty ? '<unset>' : '<set>',
    'SUPABASE_ANON_KEY': supabaseAnonKey.isEmpty ? '<unset>' : '<set>',
    'AGORA_APP_ID': agoraAppId.isEmpty ? '<unset>' : '<set>',
    'GOOGLE_MAPS_API_KEY_ANDROID': googleMapsApiKeyAndroid.isEmpty
        ? '<unset>'
        : '<set>',
    'GOOGLE_MAPS_API_KEY_IOS': googleMapsApiKeyIos.isEmpty
        ? '<unset>'
        : '<set>',
    'FIREBASE_PROJECT_ID': firebaseProjectId.isEmpty
        ? '<unset>'
        : firebaseProjectId,
    'PAYMOB_PUBLIC_KEY': paymobPublicKey.isEmpty ? '<unset>' : '<set>',
  };
}
