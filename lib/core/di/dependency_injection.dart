import 'package:docdoc/core/helpers/constans.dart';
import 'package:docdoc/core/helpers/shared_pref_helper.dart';
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
import 'package:docdoc/features/home/data/repos/notifications_repo.dart';
import 'package:docdoc/features/home/data/repos/reviews_repo.dart';
import 'package:docdoc/features/home/domain/use_cases/get_home_data_use_case.dart';
import 'package:docdoc/features/home/domain/use_cases/get_cities_by_governorate_use_case.dart';
import 'package:docdoc/features/home/domain/use_cases/get_doctors_use_case.dart';
import 'package:docdoc/features/home/domain/use_cases/appointment_use_cases.dart';
import 'package:docdoc/features/home/domain/use_cases/profile_use_cases.dart';
import 'package:docdoc/features/home/domain/use_cases/notifications_use_cases.dart';
import 'package:docdoc/features/home/domain/use_cases/get_doctor_reviews_use_case.dart';
import 'package:docdoc/features/home/data/repos/recent_searches_repo.dart';
import 'package:docdoc/features/home/domain/use_cases/recent_searches_use_cases.dart';
import 'package:docdoc/features/home/presentation/cubit/home_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/doctors_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/search_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/doctor_details_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/doctor_reviews_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/notifications_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/appointment_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/profile_cubit.dart';
import 'package:docdoc/features/inbox/data/repos/firebase_chat_repo.dart';
import 'package:docdoc/features/inbox/domain/use_cases/inbox_use_cases.dart';
import 'package:docdoc/features/inbox/presentation/cubit/inbox_cubit.dart';
import 'package:docdoc/features/inbox/presentation/cubit/chat_cubit.dart';
import 'package:docdoc/core/di/services_di.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  registerServices(getIt);
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
  getIt.registerLazySingleton<NotificationsRepo>(() => NotificationsRepo());
  getIt.registerLazySingleton<ReviewsRepo>(() => ReviewsRepo());
  getIt.registerLazySingleton<RecentSearchesRepo>(() => RecentSearchesRepo());

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
  getIt.registerLazySingleton<CancelAppointmentUseCase>(
      () => CancelAppointmentUseCase(getIt()));
  getIt.registerLazySingleton<RescheduleAppointmentUseCase>(
      () => RescheduleAppointmentUseCase(getIt()));

  // Profile use cases
  getIt.registerLazySingleton<GetUserProfileUseCase>(
      () => GetUserProfileUseCase(getIt()));
  getIt.registerLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(getIt()));

  // Notification use cases
  getIt.registerLazySingleton<GetNotificationsUseCase>(
      () => GetNotificationsUseCase(getIt()));
  getIt.registerLazySingleton<MarkAllNotificationsReadUseCase>(
      () => MarkAllNotificationsReadUseCase(getIt()));

  // Reviews use case
  getIt.registerLazySingleton<GetDoctorReviewsUseCase>(
      () => GetDoctorReviewsUseCase(getIt()));

  // Recent searches use cases
  getIt.registerLazySingleton<GetRecentSearchesUseCase>(
      () => GetRecentSearchesUseCase(getIt()));
  getIt.registerLazySingleton<AddRecentSearchUseCase>(
      () => AddRecentSearchUseCase(getIt()));
  getIt.registerLazySingleton<RemoveRecentSearchUseCase>(
      () => RemoveRecentSearchUseCase(getIt()));
  getIt.registerLazySingleton<ClearRecentSearchesUseCase>(
      () => ClearRecentSearchesUseCase(getIt()));

  // Cubits — singletons for shared state, factories for screen-scoped cubits
  getIt.registerLazySingleton<HomeCubit>(() => HomeCubit(getIt(), getIt()));
  getIt.registerLazySingleton<DoctorsCubit>(
      () => DoctorsCubit(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton<AppointmentCubit>(
      () => AppointmentCubit(getIt(), getIt(), getIt(), getIt()));
  getIt.registerLazySingleton<ProfileCubit>(
      () => ProfileCubit(getIt(), getIt()));

  // Factory cubits — fresh instance per screen entry
  getIt.registerFactory<SearchCubit>(
      () => SearchCubit(getIt(), getIt(), getIt(), getIt(), getIt()));
  getIt.registerFactory<DoctorDetailsCubit>(
      () => DoctorDetailsCubit(getIt()));
  getIt.registerFactory<DoctorReviewsCubit>(
      () => DoctorReviewsCubit(getIt()));
  getIt.registerFactory<NotificationsCubit>(
      () => NotificationsCubit(getIt(), getIt()));

  // Inbox
  final userEmail = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userEmail);
  getIt.registerLazySingleton<FirebaseChatRepo>(
      () => FirebaseChatRepo(patientId: userEmail));
  getIt.registerLazySingleton<GetConversationsUseCase>(
      () => GetConversationsUseCase(getIt()));
  getIt.registerLazySingleton<SearchConversationsUseCase>(
      () => SearchConversationsUseCase(getIt()));
  getIt.registerLazySingleton<GetMessagesUseCase>(
      () => GetMessagesUseCase(getIt()));
  getIt.registerLazySingleton<SendMessageUseCase>(
      () => SendMessageUseCase(getIt()));
  getIt.registerLazySingleton<SendImageMessageUseCase>(
      () => SendImageMessageUseCase(getIt()));
  getIt.registerLazySingleton<SendAttachmentMessageUseCase>(
      () => SendAttachmentMessageUseCase(getIt()));
  getIt.registerLazySingleton<GetDoctorsForNewMessageUseCase>(
      () => GetDoctorsForNewMessageUseCase(getIt()));
  getIt.registerLazySingleton<GetOrCreateConversationUseCase>(
      () => GetOrCreateConversationUseCase(getIt()));
  getIt.registerLazySingleton<InboxCubit>(
      () => InboxCubit(getIt(), getIt(), getIt(), getIt()));
  getIt.registerFactory<ChatCubit>(
      () => ChatCubit(getIt(), getIt(), getIt(), getIt()));
}
