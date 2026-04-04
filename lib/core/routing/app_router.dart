import 'package:docdoc/core/features/login/ui/login_screen.dart';
import 'package:docdoc/core/features/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:docdoc/core/routing/routes.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
