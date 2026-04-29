import 'package:flutter/material.dart';
import 'package:docdoc/doc_app.dart';

import 'package:docdoc/core/routing/app_router.dart';
import 'package:docdoc/core/di/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  runApp(DocApp(appRouter: AppRouter()));
}
