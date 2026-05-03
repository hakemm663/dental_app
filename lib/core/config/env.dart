enum Flavor { dev, staging, prod }

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
  static bool get isProd => flavor == Flavor.prod;
}
