import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/features/home/data/repos/doctor_repo.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';

part 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final DoctorRepo _doctorRepo;

  DoctorDetailsCubit(this._doctorRepo)
      : super(const DoctorDetailsState.initial());

  Future<void> getDoctorDetails(int doctorId) async {
    emit(const DoctorDetailsState.loading());
    try {
      final doctor = await _doctorRepo.getDoctorDetails(doctorId);
      emit(DoctorDetailsState.success(doctor: doctor));
    } catch (e) {
      emit(DoctorDetailsState.error(message: e.toString()));
    }
  }
}
