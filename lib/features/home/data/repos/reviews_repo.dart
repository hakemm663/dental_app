import 'package:docdoc/features/home/data/models/review_model.dart';

// TODO(backend): replace seeded list with real API call when endpoint is available
class ReviewsRepo {
  Future<List<ReviewModel>> getDoctorReviews(int doctorId) async => [
        ReviewModel(
          id: 1,
          reviewerName: 'Jane Cooper',
          reviewerImage: null,
          rating: 5,
          body:
              'As someone who lives in a remote area with limited access to healthcare, this telemedicine app has been a game changer for me. I can easily schedule virtual appointments with doctors and get the care I need without having to travel long distances.',
          createdAt: DateTime.now(),
        ),
        ReviewModel(
          id: 2,
          reviewerName: 'Robert Fox',
          reviewerImage: null,
          rating: 5,
          body:
              'I was initially skeptical about using a telemedicine app but this app has exceeded my expectations. The doctors are highly qualified and provide excellent care.',
          createdAt: DateTime.now(),
        ),
        ReviewModel(
          id: 3,
          reviewerName: 'Jacob Jones',
          reviewerImage: null,
          rating: 5,
          body:
              'This app has made it so much easier to manage my chronic condition. I can consult with my doctor regularly without the hassle of in-person visits.',
          createdAt: DateTime.now(),
        ),
      ];
}
