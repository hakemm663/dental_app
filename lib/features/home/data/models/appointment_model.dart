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

  const AppointmentModel({
    required this.id,
    required this.appointmentTime,
    this.doctor,
    this.patient,
    this.appointmentEndTime,
    this.notes,
    this.status,
    this.price,
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
          (json['appointment_time'] ?? json['start_time'] ?? '') as String,
      appointmentEndTime: json['appointment_end_time'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String?,
      price: (json['appointment_price'] as num?)?.toDouble(),
    );
  }
}
