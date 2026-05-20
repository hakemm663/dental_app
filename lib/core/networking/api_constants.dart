import 'package:docdoc/core/config/env.dart';

class ApiConstants {
  /// Resolved per build flavor — see [Env.apiBaseUrl].
  static String get baseUrl => Env.apiBaseUrl;

  // Auth
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String logout = 'auth/logout';

  // User
  static const String userProfile = 'user/profile';
  static const String updateProfile = 'user/update';

  // Home
  static const String home = 'home/index';

  // Governorate
  static const String governorates = 'governrate/index';

  // City
  static const String cities = 'city/index';
  static String citiesByGovernorate(int governorateId) =>
      'city/show/$governorateId';

  // Specialization
  static const String specializations = 'specialization/index';

  // Doctor
  static const String doctors = 'doctor/index';
  static String doctorDetails(int id) => 'doctor/show/$id';
  static const String filterDoctors = 'doctor/doctor-filter';
  static const String searchDoctors = 'doctor/doctor-search';

  // Medical Records
  static const String medicalRecords = 'user/medical-records';

  // Appointment
  static const String appointments = 'appointment/index';
  static const String storeAppointment = 'appointment/store';
  static String cancelAppointment(int id) => 'appointment/cancel/$id';
  static String rescheduleAppointment(int id) => 'appointment/reschedule/$id';
}
