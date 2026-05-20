/// Build flavors. Selected at compile time via `--dart-define=ENV=<name>`;
/// defaults to [Flavor.dev] when the define is absent.
enum Flavor { dev, staging, prod }

/// Compile-time environment configuration.
///
/// The active flavor is chosen with `--dart-define=ENV=dev|staging|prod`.
/// The production API base URL can be overridden without a code change via
/// `--dart-define=PROD_API_BASE_URL=https://...`.
class Env {
  Env._();

  static const String _value =
      String.fromEnvironment('ENV', defaultValue: 'dev');

  static Flavor get flavor => switch (_value) {
        'prod' => Flavor.prod,
        'staging' => Flavor.staging,
        _ => Flavor.dev,
      };

  static bool get isDev => flavor == Flavor.dev;
  static bool get isStaging => flavor == Flavor.staging;
  static bool get isProd => flavor == Flavor.prod;

  /// VCare integration/test backend — used by the dev and staging flavors.
  static const String _integrationApiUrl =
      'https://vcare.integration25.com/api/';

  /// Production VCare backend.
  ///
  /// TODO(launch-blocker): set the real production base URL before the first
  /// store release. Until the VCare team confirms it, this falls back to the
  /// integration server so builds keep working — but a `prod` build pointed at
  /// the test backend must NOT ship. Pass it at build time with
  /// `--dart-define=PROD_API_BASE_URL=https://...` or hardcode it here.
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
}
