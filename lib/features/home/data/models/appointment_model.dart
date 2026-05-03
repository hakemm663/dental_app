class AppointmentModel {
  final int id;
  final int doctorId;
  final int userId;
  final String startTime;
  final String? notes;
  final String? status;
  final String? createdAt;

  const AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.userId,
    required this.startTime,
    this.notes,
    this.status,
    this.createdAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        id: json['id'] as int,
        doctorId: json['doctor_id'] as int,
        userId: json['user_id'] as int,
        startTime: json['start_time'] as String,
        notes: json['notes'] as String?,
        status: json['status'] as String?,
        createdAt: json['created_at'] as String?,
      );
}
