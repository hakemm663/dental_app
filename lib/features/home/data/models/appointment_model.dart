import 'package:json_annotation/json_annotation.dart';

part 'appointment_model.g.dart';

@JsonSerializable()
class AppointmentModel {
  final int id;
  @JsonKey(name: 'doctor_id')
  final int doctorId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'start_time')
  final String startTime;
  final String? notes;
  final String? status;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.userId,
    required this.startTime,
    this.notes,
    this.status,
    this.createdAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}
