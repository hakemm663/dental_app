part of 'notification_prefs_cubit.dart';

class NotificationPrefsState {
  final bool push;
  final bool sound;
  final bool vibrate;
  final bool appUpdates;
  final bool specialOffers;
  final bool isLoading;

  const NotificationPrefsState({
    required this.push,
    required this.sound,
    required this.vibrate,
    required this.appUpdates,
    required this.specialOffers,
    required this.isLoading,
  });

  const NotificationPrefsState.initial()
    : this(
        push: true,
        sound: true,
        vibrate: true,
        appUpdates: true,
        specialOffers: false,
        isLoading: false,
      );

  NotificationPrefsState copyWith({
    bool? push,
    bool? sound,
    bool? vibrate,
    bool? appUpdates,
    bool? specialOffers,
    bool? isLoading,
  }) {
    return NotificationPrefsState(
      push: push ?? this.push,
      sound: sound ?? this.sound,
      vibrate: vibrate ?? this.vibrate,
      appUpdates: appUpdates ?? this.appUpdates,
      specialOffers: specialOffers ?? this.specialOffers,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
