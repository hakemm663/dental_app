import 'package:dio/dio.dart';
import 'api_constants.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  // ── Auth ──────────────────────────────────────────────────────────────────

  Future<Response> login({
    required String email,
    required String password,
  }) =>
      _dio.post(
        ApiConstants.login,
        data: FormData.fromMap({'email': email, 'password': password}),
      );

  Future<Response> register({
    required String name,
    required String email,
    required String phone,
    required int gender,
    required String password,
    required String passwordConfirmation,
  }) =>
      _dio.post(
        ApiConstants.register,
        data: FormData.fromMap({
          'name': name,
          'email': email,
          'phone': phone,
          'gender': gender,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

  Future<Response> logout() => _dio.post(ApiConstants.logout);

  // ── User ──────────────────────────────────────────────────────────────────

  Future<Response> getUserProfile() => _dio.get(ApiConstants.userProfile);

  Future<Response> updateProfile(Map<String, dynamic> fields) =>
      _dio.post(
        ApiConstants.updateProfile,
        data: FormData.fromMap(fields),
      );

  // ── Home ──────────────────────────────────────────────────────────────────

  Future<Response> getHomeData() => _dio.get(ApiConstants.home);

  // ── Governorate ───────────────────────────────────────────────────────────

  Future<Response> getAllGovernorates() =>
      _dio.get(ApiConstants.governorates);

  // ── City ──────────────────────────────────────────────────────────────────

  Future<Response> getAllCities() => _dio.get(ApiConstants.cities);

  Future<Response> getCitiesByGovernorate(int governorateId) =>
      _dio.get(ApiConstants.citiesByGovernorate(governorateId));

  // ── Specialization ────────────────────────────────────────────────────────

  Future<Response> getAllSpecializations() =>
      _dio.get(ApiConstants.specializations);

  // ── Doctor ────────────────────────────────────────────────────────────────

  Future<Response> getAllDoctors() => _dio.get(ApiConstants.doctors);

  Future<Response> getDoctorDetails(int id) =>
      _dio.get(ApiConstants.doctorDetails(id));

  Future<Response> filterDoctors({int? cityId, int? specializationId}) =>
      _dio.get(
        ApiConstants.filterDoctors,
        queryParameters: {
          if (cityId != null) 'city': cityId,
          if (specializationId != null) 'specialization': specializationId,
        },
      );

  Future<Response> searchDoctors(String name) =>
      _dio.get(ApiConstants.searchDoctors, queryParameters: {'name': name});

  // ── Appointment ───────────────────────────────────────────────────────────

  Future<Response> getAllAppointments() =>
      _dio.get(ApiConstants.appointments);

  Future<Response> storeAppointment({
    required int doctorId,
    String? notes,
  }) =>
      _dio.post(
        ApiConstants.storeAppointment,
        data: FormData.fromMap({
          'doctor_id': doctorId,
          if (notes != null) 'notes': notes,
        }),
      );
}
