part of 'doctor_reviews_cubit.dart';

class DoctorReviewsState {
  final List<ReviewModel> reviews;
  final bool isLoading;
  final String? errorMessage;

  const DoctorReviewsState({
    required this.reviews,
    required this.isLoading,
    this.errorMessage,
  });

  const DoctorReviewsState.initial()
      : this(reviews: const [], isLoading: false);

  const DoctorReviewsState.loading()
      : this(reviews: const [], isLoading: true);

  const DoctorReviewsState.loaded({required List<ReviewModel> reviews})
      : this(reviews: reviews, isLoading: false);

  DoctorReviewsState.error({required String message})
      : this(reviews: const [], isLoading: false, errorMessage: message);
}
