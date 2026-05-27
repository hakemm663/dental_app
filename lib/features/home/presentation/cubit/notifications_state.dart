part of 'notifications_cubit.dart';

class NotificationsState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? errorMessage;

  const NotificationsState({
    required this.notifications,
    required this.isLoading,
    this.errorMessage,
  });

  const NotificationsState.initial()
    : this(notifications: const [], isLoading: false);

  const NotificationsState.loading()
    : this(notifications: const [], isLoading: true);

  const NotificationsState.loaded({
    required List<NotificationModel> notifications,
  }) : this(notifications: notifications, isLoading: false);

  NotificationsState.error({required String message})
    : this(notifications: const [], isLoading: false, errorMessage: message);

  int get unreadCount => notifications.where((n) => !n.isRead).length;
}
