import 'package:docdoc/features/login/ui/login_screen.dart';
import 'package:docdoc/features/onboarding/onboarding_screen.dart';
import 'package:docdoc/features/home/ui/screens/home_screen.dart';
import 'package:docdoc/features/home/ui/screens/doctor_details_screen.dart';
import 'package:docdoc/features/home/ui/screens/book_appointment_screen.dart';
import 'package:docdoc/features/home/ui/screens/appointments_screen.dart';
import 'package:docdoc/features/home/ui/screens/profile_screen.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/features/login/logic/cubit/login_cubit.dart';
import 'package:docdoc/features/home/logic/cubit/home_cubit.dart';
import 'package:docdoc/features/home/logic/cubit/doctors_cubit.dart';
import 'package:docdoc/features/home/logic/cubit/doctor_details_cubit.dart';
import 'package:docdoc/features/home/logic/cubit/appointment_cubit.dart';
import 'package:docdoc/features/home/logic/cubit/profile_cubit.dart';
import 'package:docdoc/core/di/dependency_injection.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<HomeCubit>()),
              BlocProvider(create: (context) => getIt<DoctorsCubit>()),
            ],
            child: const HomeScreen(),
          ),
        );
      case Routes.doctorDetails:
        final doctorId = arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<DoctorDetailsCubit>(),
            child: DoctorDetailsScreen(doctorId: doctorId),
          ),
        );
      case Routes.bookAppointment:
        final doctor = arguments as DoctorModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AppointmentCubit>(),
            child: BookAppointmentScreen(doctor: doctor),
          ),
        );
      case Routes.appointments:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AppointmentCubit>(),
            child: const AppointmentsScreen(),
          ),
        );
      case Routes.profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ProfileCubit>(),
            child: const ProfileScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route define for ${settings.name}')),
          ),
        );
    }
  }
}

