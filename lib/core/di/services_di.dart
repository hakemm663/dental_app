import 'package:docdoc/core/services/agora_service.dart';
import 'package:docdoc/core/services/agora_token_service.dart';
import 'package:docdoc/core/services/firebase_storage_service.dart';
import 'package:docdoc/core/services/media_picker_service.dart';
import 'package:get_it/get_it.dart';

void registerServices(GetIt getIt) {
  getIt.registerLazySingleton<AgoraService>(() => AgoraService());
  getIt.registerLazySingleton<AgoraTokenService>(() => AgoraTokenService());
  getIt.registerLazySingleton<MediaPickerService>(() => MediaPickerService());
  getIt.registerLazySingleton<FirebaseStorageService>(
      () => FirebaseStorageService());
}
