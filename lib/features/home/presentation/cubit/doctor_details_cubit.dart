import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/domain/use_cases/get_doctors_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final GetDoctorDetailsUseCase _getDoctorDetailsUseCase;

  DoctorDetailsCubit(this._getDoctorDetailsUseCase)
      : super(const DoctorDetailsState.initial());

  Future<void> getDoctorDetails(int doctorId) async {
    emit(const DoctorDetailsState.loading());
    final result = await _getDoctorDetailsUseCase(doctorId);
    switch (result) {
      case Success(:final data):
        emit(DoctorDetailsState.success(doctor: data));
      case Failure(:final errMsg):
        emit(DoctorDetailsState.error(message: errMsg));
    }
  }
}
