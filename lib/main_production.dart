import 'package:docdoc/core/app/bootstrap.dart';

/// Production entrypoint.
///   flutter run --flavor production -t lib/main_production.dart \
///     --dart-define-from-file=env/production.json
Future<void> main() => bootstrap();
