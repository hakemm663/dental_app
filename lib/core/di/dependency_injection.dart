import 'package:dio/dio.dart';
import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/core/networking/dio_factory.dart';
import 'package:docdoc/features/login/data/repos/login_repo.dart';
import 'package:docdoc/features/login/logic/cubit/login_cubit.dart';
import 'package:docdoc/features/home/data/repos/home_repo.dart';
import 'package:docdoc/features/home/data/repos/doctor_repo.dart';
import 'package:docdoc/features/home/data/repos/appointment_repo.dart';
import 'package:docdoc/features/home/logic/cubit/home_cubit.dart';
import 'package:docdoc/features/home/logic/cubit/doctors_cubit.dart';
import 'package:docdoc/features/home/logic/cubit/doctor_details_cubit.dart';
import 'package:docdoc/features/home/logic/cubit/appointment_cubit.dart';
import 'package:docdoc/features/home/logic/cubit/profile_cubit.dart';

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Dio & ApiServices
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  //login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerLazySingleton<LoginCubit>(() => LoginCubit(getIt()));

  // home
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt()));
  getIt.registerLazySingleton<HomeCubit>(() => HomeCubit(getIt()));

  // doctors
  getIt.registerLazySingleton<DoctorRepo>(() => DoctorRepo(getIt()));
  getIt.registerLazySingleton<DoctorsCubit>(() => DoctorsCubit(getIt()));
  getIt.registerLazySingleton<DoctorDetailsCubit>(
      () => DoctorDetailsCubit(getIt()));

  // appointments & profile
  getIt.registerLazySingleton<AppointmentRepo>(() => AppointmentRepo(getIt()));
  getIt.registerLazySingleton<AppointmentCubit>(
      () => AppointmentCubit(getIt()));
  getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit(getIt()));
}

