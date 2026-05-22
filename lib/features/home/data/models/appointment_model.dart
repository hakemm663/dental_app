import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/data/models/user_model.dart';

class AppointmentModel {
  final int id;
  final DoctorModel? doctor;
  final UserModel? patient;
  final String appointmentTime;
  final String? appointmentEndTime;
  final String? notes;
  final String? status;
  final double? price;
  final String? appointmentType;

  const AppointmentModel({
    required this.id,
    required this.appointmentTime,
    this.doctor,
    this.patient,
    this.appointmentEndTime,
    this.notes,
    this.status,
    this.price,
    this.appointmentType,
  });

  int? get doctorId => doctor?.id;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final doctorJson = json['doctor'] as Map<String, dynamic>?;
    final patientJson = json['patient'] as Map<String, dynamic>?;
    return AppointmentModel(
      id: json['id'] as int,
      doctor: doctorJson != null ? DoctorModel.fromJson(doctorJson) : null,
      patient: patientJson != null ? UserModel.fromJson(patientJson) : null,
      appointmentTime:
          (json['start_time'] ?? json['appointment_time'] ?? '') as String,
      appointmentEndTime: json['appointment_end_time'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      appointmentType: json['appointment_type'] as String?,
    );
  }

  AppointmentModel copyWith({
    int? id,
    DoctorModel? doctor,
    UserModel? patient,
    String? appointmentTime,
    String? appointmentEndTime,
    String? notes,
    String? status,
    double? price,
    String? appointmentType,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      doctor: doctor ?? this.doctor,
      patient: patient ?? this.patient,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      appointmentEndTime: appointmentEndTime ?? this.appointmentEndTime,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      price: price ?? this.price,
      appointmentType: appointmentType ?? this.appointmentType,
    );
  }
}
