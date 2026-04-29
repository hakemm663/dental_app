// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      id: (json['id'] as num).toInt(),
      doctorId: (json['doctor_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      startTime: json['start_time'] as String,
      notes: json['notes'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctor_id': instance.doctorId,
      'user_id': instance.userId,
      'start_time': instance.startTime,
      'notes': instance.notes,
      'status': instance.status,
      'created_at': instance.createdAt,
    };
