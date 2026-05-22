import 'package:docdoc/features/home/data/models/review_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewsRepo {
  final SupabaseClient _client;

  const ReviewsRepo(this._client);

  Future<List<ReviewModel>> getDoctorReviews(int doctorId) async {
    final data = await _client
        .from('doctor_reviews')
        .select()
        .eq('doctor_id', doctorId)
        .order('created_at', ascending: false);
    return data.map((e) => ReviewModel.fromJson(e)).toList();
  }
}
