import 'package:docdoc/features/register/presentation/register_screen.dart';
import 'package:docdoc/features/forgot_password/presentation/forgot_password_screen.dart';
import 'package:docdoc/features/forgot_password/presentation/verify_code_screen.dart';
import 'package:docdoc/features/forgot_password/presentation/new_password_screen.dart';
import 'package:docdoc/features/forgot_password/presentation/password_changed_screen.dart';
import 'package:docdoc/features/login/presentation/login_screen.dart';
import 'package:docdoc/features/onboarding/onboarding_screen.dart';
import 'package:docdoc/features/home/presentation/screens/home_screen.dart';
import 'package:docdoc/features/home/presentation/screens/doctor_details_screen.dart';
import 'package:docdoc/features/home/presentation/screens/book_appointment_screen.dart';
import 'package:docdoc/features/home/presentation/screens/appointments_screen.dart';
import 'package:docdoc/features/home/presentation/screens/profile_screen.dart';
import 'package:docdoc/features/home/presentation/screens/specialities_screen.dart';
import 'package:docdoc/features/home/presentation/screens/recommendation_doctors_screen.dart';
import 'package:docdoc/features/home/presentation/screens/notifications_screen.dart';
import 'package:docdoc/features/home/presentation/screens/find_nearby_screen.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/features/register/presentation/cubit/register_cubit.dart';
import 'package:docdoc/features/login/presentation/cubit/login_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/home_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/doctors_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/doctor_details_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/doctor_reviews_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/notifications_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/appointment_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/profile_cubit.dart';
import 'package:docdoc/core/di/dependency_injection.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<RegisterCubit>(),
            child: const RegisterScreen(),
          ),
        );
      case Routes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );
      case Routes.verifyCode:
        return MaterialPageRoute(
          builder: (_) => const VerifyCodeScreen(),
        );
      case Routes.newPassword:
        return MaterialPageRoute(
          builder: (_) => const NewPasswordScreen(),
        );
      case Routes.passwordChanged:
        return MaterialPageRoute(
          builder: (_) => const PasswordChangedScreen(),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<HomeCubit>()),
              BlocProvider.value(value: getIt<DoctorsCubit>()),
            ],
            child: const HomeScreen(),
          ),
        );
      case Routes.specialitiesScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<HomeCubit>()),
              BlocProvider.value(value: getIt<DoctorsCubit>()),
            ],
            child: const SpecialitiesScreen(),
          ),
        );
      case Routes.recommendationDoctors:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<HomeCubit>()),
              BlocProvider.value(value: getIt<DoctorsCubit>()),
            ],
            child: const RecommendationDoctorsScreen(),
          ),
        );
      case Routes.notifications:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<NotificationsCubit>(),
            child: const NotificationsScreen(),
          ),
        );
      case Routes.findNearby:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<DoctorsCubit>(),
            child: const FindNearbyScreen(),
          ),
        );
      case Routes.doctorDetails:
        final doctorId = arguments as int;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<DoctorDetailsCubit>()),
              BlocProvider(create: (_) => getIt<DoctorReviewsCubit>()),
            ],
            child: DoctorDetailsScreen(doctorId: doctorId),
          ),
        );
      case Routes.bookAppointment:
        final doctor = arguments as DoctorModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<AppointmentCubit>(),
            child: BookAppointmentScreen(doctor: doctor),
          ),
        );
      case Routes.appointments:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<AppointmentCubit>(),
            child: const AppointmentsScreen(),
          ),
        );
      case Routes.profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<ProfileCubit>(),
            child: const ProfileScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
