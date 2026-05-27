import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/user_model.dart';
import 'package:docdoc/features/home/domain/use_cases/profile_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UpdateAvatarUseCase _updateAvatarUseCase;

  ProfileCubit(
    this._getUserProfileUseCase,
    this._updateProfileUseCase,
    this._updateAvatarUseCase,
  ) : super(const ProfileState.initial());

  Future<void> getUserProfile() async {
    emit(const ProfileState.loading());
    final result = await _getUserProfileUseCase();
    switch (result) {
      case Success(:final data):
        emit(ProfileState.success(user: data));
      case Failure(:final errMsg):
        emit(ProfileState.error(message: errMsg));
    }
  }

  Future<void> updateAvatar(String filePath) async {
    emit(state.copyWith(isUpdating: true));
    final result = await _updateAvatarUseCase(filePath);
    switch (result) {
      case Success(:final data):
        emit(ProfileState.success(user: data));
      case Failure(:final errMsg):
        emit(state.copyWith(isUpdating: false, errorMessage: errMsg));
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
    final fields = <String, dynamic>{
      'name': ?name,
      'email': ?email,
      'phone': ?phone,
      'gender': ?gender,
      'password': ?password,
    };
    final result = await _updateProfileUseCase(fields);
    switch (result) {
      case Success(:final data):
        emit(ProfileState.success(user: data));
      case Failure(:final errMsg):
        emit(ProfileState.error(message: errMsg));
    }
  }
}
