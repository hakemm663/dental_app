import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/appointment_model.dart';
import 'package:docdoc/features/home/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentRepo {
  final SupabaseClient _client;

  const AppointmentRepo(this._client);

  // Appointment rows are RLS-scoped to the signed-in user.
  static const _appointmentSelect =
      '*, doctor:doctors(*, specialization:specializations(id, name), '
      'city:cities(id, name, governorate:governorates(id, name)), '
      'clinic:clinics(address, phone))';

  Future<ApiResult<List<AppointmentModel>>> getAllAppointments() async {
    try {
      final data = await _client
          .from('appointments')
          .select(_appointmentSelect)
          .order('start_time', ascending: false);
      return Success(
        data.map((e) => AppointmentModel.fromJson(e)).toList(),
      );
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<AppointmentModel>> storeAppointment({
    required int doctorId,
    required String startTime,
    String? notes,
    String? paymentMethod,
    String? cardBrand,
    double? subtotal,
    double? tax,
    double? total,
    String? appointmentType,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return const Failure('You must be signed in to book an appointment.');
      }
      final inserted = await _client
          .from('appointments')
          .insert({
            'user_id': userId,
            'doctor_id': doctorId,
            'start_time': startTime,
            'notes': ?notes,
            'appointment_type': _normalizeType(appointmentType),
            'price': total ?? ((subtotal ?? 0) + (tax ?? 0)),
            'payment_method': ?paymentMethod,
          })
          .select(_appointmentSelect)
          .single();
      return Success(AppointmentModel.fromJson(inserted));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<void>> cancelAppointment(int id) async {
    try {
      await _client
          .from('appointments')
          .update({'status': 'cancelled'}).eq('id', id);
      return const Success(null);
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<AppointmentModel>> rescheduleAppointment({
    required int id,
    required String startTime,
    String? appointmentType,
  }) async {
    try {
      final updated = await _client
          .from('appointments')
          .update({
            'start_time': startTime,
            if (appointmentType != null)
              'appointment_type': _normalizeType(appointmentType),
          })
          .eq('id', id)
          .select(_appointmentSelect)
          .single();
      return Success(AppointmentModel.fromJson(updated));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UserModel>> getUserProfile() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return const Failure('You are not signed in.');
      // The handle_new_user trigger creates a profiles row on signup, but
      // older accounts (or accounts created via the dashboard) may not have
      // one yet — insert a stub so the personal-info screen never errors on
      // first open.
      var profile = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      profile ??= await _client.from('profiles').insert({
        'id': user.id,
        'full_name': user.userMetadata?['full_name'],
        'phone': user.userMetadata?['phone'],
      }).select().single();
      return Success(_userFrom(profile, user));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UserModel>> updateProfile(
      Map<String, dynamic> fields) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return const Failure('You are not signed in.');
      final name = fields['name'] ?? fields['full_name'];
      final payload = <String, dynamic>{
        'full_name': ?name,
        'phone': ?fields['phone'],
        'gender': ?fields['gender'],
      };
      final updated = await _client
          .from('profiles')
          .update(payload)
          .eq('id', user.id)
          .select()
          .single();
      return Success(_userFrom(updated, user));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }

  UserModel _userFrom(Map<String, dynamic> profile, User authUser) => UserModel(
        id: authUser.id,
        name: (profile['full_name'] as String?) ?? '',
        email: authUser.email ?? '',
        phone: (profile['phone'] as String?) ?? '',
        gender: profile['gender'] as String?,
        createdAt: profile['created_at'] as String?,
      );

  // The DB allows only 'in_person' | 'video'; map the UI type onto that.
  String _normalizeType(String? type) =>
      (type ?? '').toLowerCase().contains('video') ? 'video' : 'in_person';
}
