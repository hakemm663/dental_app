import 'package:docdoc/features/home/data/models/notification_model.dart';

// TODO(backend): replace seeded list with real API call when endpoint is available
class NotificationsRepo {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 1,
      type: NotificationType.appointmentSuccess,
      title: 'Appointment Success',
      body:
          "Congratulations - your appointment is confirmed! We're looking forward to meeting with you and helping you achieve your goals.",
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: 2,
      type: NotificationType.scheduleChanged,
      title: 'Schedule Changed',
      body:
          "You have successfully changed your appointment with Dr. Randy Wigham. Don't forget to active your reminder.",
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    NotificationModel(
      id: 3,
      type: NotificationType.videoCall,
      title: 'Video Call Appointment',
      body:
          "We'll send you a link to join the call at the booking details, so all you need is a computer or mobile device with a camera and an internet connection.",
      createdAt: DateTime.now().subtract(const Duration(hours: 7)),
      isRead: true,
    ),
    NotificationModel(
      id: 4,
      type: NotificationType.appointmentCancelled,
      title: 'Appointment Cancelled',
      body:
          'You have successfully cancelled your appointment with Dr. Randy Wigham. 50% of the funds will be returned to your account.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: 5,
      type: NotificationType.paymentAdded,
      title: 'New Payment Added!',
      body: 'Your payment has been successfully linked with Docdoc.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
    ),
  ];

  Future<List<NotificationModel>> getNotifications() async =>
      List.unmodifiable(_notifications);

  Future<void> markAllAsRead() async {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}
