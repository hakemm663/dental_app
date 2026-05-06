import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/review_model.dart';
import 'package:docdoc/features/home/data/repos/reviews_repo.dart';

class GetDoctorReviewsUseCase {
  final ReviewsRepo _repo;

  const GetDoctorReviewsUseCase(this._repo);

  Future<ApiResult<List<ReviewModel>>> call(int doctorId) async {
    try {
      return Success(await _repo.getDoctorReviews(doctorId));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
