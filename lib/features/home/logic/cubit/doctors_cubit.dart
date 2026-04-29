import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/features/home/data/repos/doctor_repo.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';

part 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  final DoctorRepo _doctorRepo;

  DoctorsCubit(this._doctorRepo) : super(const DoctorsState.initial());

  Future<void> getAllDoctors() async {
    emit(const DoctorsState.loading());
    try {
      final doctors = await _doctorRepo.getAllDoctors();
      emit(DoctorsState.success(doctors: doctors));
    } catch (e) {
      emit(DoctorsState.error(message: e.toString()));
    }
  }

  Future<void> filterDoctors({int? cityId, int? specializationId}) async {
    emit(const DoctorsState.loading());
    try {
      final doctors = await _doctorRepo.filterDoctors(
        cityId: cityId,
        specializationId: specializationId,
      );
      emit(DoctorsState.success(doctors: doctors));
    } catch (e) {
      emit(DoctorsState.error(message: e.toString()));
    }
  }

  Future<void> searchDoctors(String name) async {
    emit(const DoctorsState.loading());
    try {
      final doctors = await _doctorRepo.searchDoctors(name);
      emit(DoctorsState.success(doctors: doctors));
    } catch (e) {
      emit(DoctorsState.error(message: e.toString()));
    }
  }
}
