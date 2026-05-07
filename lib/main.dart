import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/helpers/constans.dart';
import 'package:docdoc/core/helpers/shared_pref_helper.dart';
import 'package:docdoc/core/routing/app_router.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/doc_app.dart';
import 'package:docdoc/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupGetIt();
  final token =
      await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
  final initialRoute =
      token.isNotEmpty ? Routes.homeScreen : Routes.onBoardingScreen;
  runApp(DocApp(appRouter: AppRouter(), initialRoute: initialRoute));
  FlutterNativeSplash.remove();
}
