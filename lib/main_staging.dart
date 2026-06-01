import 'package:docdoc/core/app/bootstrap.dart';

/// Staging entrypoint.
///   flutter run --flavor staging -t lib/main_staging.dart \
///     --dart-define-from-file=env/staging.json
Future<void> main() => bootstrap();
