import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/features/home/data/repos/appointment_repo.dart';
import 'package:docdoc/features/home/data/models/user_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AppointmentRepo _appointmentRepo;

  ProfileCubit(this._appointmentRepo) : super(const ProfileState.initial());

  Future<void> getUserProfile() async {
    emit(const ProfileState.loading());
    try {
      final user = await _appointmentRepo.getUserProfile();
      emit(ProfileState.success(user: user));
    } catch (e) {
      emit(ProfileState.error(message: e.toString()));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    int? gender,
    String? password,
  }) async {
    emit(const ProfileState.updating());
    try {
      final user = await _appointmentRepo.updateProfile(
        name: name,
        email: email,
        phone: phone,
        gender: gender,
        password: password,
      );
      emit(ProfileState.success(user: user));
    } catch (e) {
      emit(ProfileState.error(message: e.toString()));
    }
  }
}
