import 'package:docdoc/core/config/env.dart';
import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/routing/app_router.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/doc_app.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Shared startup sequence used by every flavor entrypoint
/// (`main_dev.dart`, `main_staging.dart`, `main_production.dart`).
/// The flavor itself is selected at compile time via the `ENV` dart-define
/// and surfaced through [Env.flavor]; this function is flavor-agnostic.
Future<void> bootstrap() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  // No `options:` — each flavor links its own google-services.json (Android)
  // and GoogleService-Info.plist (iOS) at build time, and the Firebase SDK
  // picks up that native config automatically. Passing the generated
  // DefaultFirebaseOptions would force every flavor onto the production
  // Firebase app and silently break dev/staging Auth + App Check.
  await Firebase.initializeApp();

  // Route Flutter framework errors and uncaught async errors to Crashlytics.
  // Collection is disabled in debug so local crashes surface in the console
  // rather than polluting the production dashboard.
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    !kDebugMode,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  binding.platformDispatcher.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await FirebaseAppCheck.instance.activate(
    androidProvider: kReleaseMode
        ? AndroidProvider.playIntegrity
        : AndroidProvider.debug,
    appleProvider: kReleaseMode
        ? AppleProvider.appAttestWithDeviceCheckFallback
        : AppleProvider.debug,
  );

  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

  if (kDebugMode) {
    debugPrint('[docdoc] booted: ${Env.summary}');
  }

  await setupGetIt();
  final session = Supabase.instance.client.auth.currentSession;
  final initialRoute = session != null
      ? Routes.homeScreen
      : Routes.onBoardingScreen;
  runApp(DocApp(appRouter: AppRouter(), initialRoute: initialRoute));
  FlutterNativeSplash.remove();
}
