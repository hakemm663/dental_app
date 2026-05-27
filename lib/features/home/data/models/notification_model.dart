enum NotificationType {
  appointmentSuccess,
  scheduleChanged,
  videoCall,
  appointmentCancelled,
  paymentAdded,
  unknown,
}

class NotificationModel {
  final int id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
  });

  // TODO(backend): wire to real notifications endpoint when available
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as int,
        type: _typeFromString(json['type'] as String? ?? ''),
        title: json['title'] as String,
        body: json['body'] as String,
        createdAt:
            DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
        isRead: json['is_read'] as bool? ?? false,
      );

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
    id: id,
    type: type,
    title: title,
    body: body,
    createdAt: createdAt,
    isRead: isRead ?? this.isRead,
  );

  static NotificationType _typeFromString(String raw) => switch (raw) {
    'appointment_success' => NotificationType.appointmentSuccess,
    'schedule_changed' => NotificationType.scheduleChanged,
    'video_call' => NotificationType.videoCall,
    'appointment_cancelled' => NotificationType.appointmentCancelled,
    'payment_added' => NotificationType.paymentAdded,
    _ => NotificationType.unknown,
  };
}
