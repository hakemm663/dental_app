import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/core/networking/dio_factory.dart';
import 'package:docdoc/features/login/data/repos/login_repo.dart';
import 'package:docdoc/features/login/domain/use_cases/login_use_case.dart';
import 'package:docdoc/features/login/presentation/cubit/login_cubit.dart';
import 'package:docdoc/features/register/data/repos/register_repo.dart';
import 'package:docdoc/features/register/domain/use_cases/register_use_case.dart';
import 'package:docdoc/features/register/presentation/cubit/register_cubit.dart';
import 'package:docdoc/features/home/data/repos/home_repo.dart';
import 'package:docdoc/features/home/data/repos/doctor_repo.dart';
import 'package:docdoc/features/home/data/repos/appointment_repo.dart';
import 'package:docdoc/features/home/domain/use_cases/get_home_data_use_case.dart';
import 'package:docdoc/features/home/domain/use_cases/get_cities_by_governorate_use_case.dart';
import 'package:docdoc/features/home/domain/use_cases/get_doctors_use_case.dart';
import 'package:docdoc/features/home/domain/use_cases/appointment_use_cases.dart';
import 'package:docdoc/features/home/domain/use_cases/profile_use_cases.dart';
import 'package:docdoc/features/home/presentation/cubit/home_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/doctors_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/doctor_details_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/appointment_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/profile_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Networking
  getIt.registerLazySingleton<ApiService>(() => ApiService(DioFactory.getDio()));

  // Login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<LoginCubit>(() => LoginCubit(getIt()));

  // Register
  getIt.registerLazySingleton<RegisterRepo>(() => RegisterRepo(getIt()));
  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton<RegisterCubit>(() => RegisterCubit(getIt()));

  // Repos
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt()));
  getIt.registerLazySingleton<DoctorRepo>(() => DoctorRepo(getIt()));
  getIt.registerLazySingleton<AppointmentRepo>(() => AppointmentRepo(getIt()));

  // Home use cases
  getIt.registerLazySingleton<GetHomeDataUseCase>(
      () => GetHomeDataUseCase(getIt()));
  getIt.registerLazySingleton<GetCitiesByGovernorateUseCase>(
      () => GetCitiesByGovernorateUseCase(getIt()));

  // Doctor use cases
  getIt.registerLazySingleton<GetDoctorsUseCase>(
      () => GetDoctorsUseCase(getIt()));
  getIt.registerLazySingleton<FilterDoctorsUseCase>(
      () => FilterDoctorsUseCase(getIt()));
  getIt.registerLazySingleton<SearchDoctorsUseCase>(
      () => SearchDoctorsUseCase(getIt()));
  getIt.registerLazySingleton<GetDoctorDetailsUseCase>(
      () => GetDoctorDetailsUseCase(getIt()));

  // Appointment use cases
  getIt.registerLazySingleton<GetAppointmentsUseCase>(
      () => GetAppointmentsUseCase(getIt()));
  getIt.registerLazySingleton<StoreAppointmentUseCase>(
      () => StoreAppointmentUseCase(getIt()));

  // Profile use cases
  getIt.registerLazySingleton<GetUserProfileUseCase>(
      () => GetUserProfileUseCase(getIt()));
  getIt.registerLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(getIt()));

  // Cubits
  getIt.registerLazySingleton<HomeCubit>(
      () => HomeCubit(getIt(), getIt()));
  getIt.registerLazySingleton<DoctorsCubit>(
      () => DoctorsCubit(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton<DoctorDetailsCubit>(
      () => DoctorDetailsCubit(getIt()));
  getIt.registerLazySingleton<AppointmentCubit>(
      () => AppointmentCubit(getIt(), getIt()));
  getIt.registerLazySingleton<ProfileCubit>(
      () => ProfileCubit(getIt(), getIt()));
}
