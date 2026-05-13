import 'package:docdoc/features/home/domain/use_cases/settings_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_prefs_state.dart';

class NotificationPrefsCubit extends Cubit<NotificationPrefsState> {
  final GetNotificationPrefsUseCase _getUseCase;
  final SetNotificationPrefUseCase _setUseCase;

  NotificationPrefsCubit(this._getUseCase, this._setUseCase)
      : super(const NotificationPrefsState.initial());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final prefs = await _getUseCase();
    emit(state.copyWith(
      push: prefs['push'],
      sound: prefs['sound'],
      vibrate: prefs['vibrate'],
      appUpdates: prefs['appUpdates'],
      specialOffers: prefs['specialOffers'],
      isLoading: false,
    ));
  }

  Future<void> toggle(String key, bool value) async {
    emit(switch (key) {
      'push' => state.copyWith(push: value),
      'sound' => state.copyWith(sound: value),
      'vibrate' => state.copyWith(vibrate: value),
      'appUpdates' => state.copyWith(appUpdates: value),
      'specialOffers' => state.copyWith(specialOffers: value),
      _ => state,
    });
    await _setUseCase(key, value);
  }
}
