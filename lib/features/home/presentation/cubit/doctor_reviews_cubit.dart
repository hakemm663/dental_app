import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/review_model.dart';
import 'package:docdoc/features/home/domain/use_cases/get_doctor_reviews_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_reviews_state.dart';

class DoctorReviewsCubit extends Cubit<DoctorReviewsState> {
  final GetDoctorReviewsUseCase _getReviewsUseCase;

  DoctorReviewsCubit(this._getReviewsUseCase)
    : super(const DoctorReviewsState.initial());

  Future<void> loadReviews(int doctorId) async {
    emit(const DoctorReviewsState.loading());
    final result = await _getReviewsUseCase(doctorId);
    switch (result) {
      case Success(:final data):
        emit(DoctorReviewsState.loaded(reviews: data));
      case Failure(:final errMsg):
        emit(DoctorReviewsState.error(message: errMsg));
    }
  }
}
