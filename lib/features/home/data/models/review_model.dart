class ReviewModel {
  final int id;
  final String reviewerName;
  final String? reviewerImage;
  final int rating;
  final String body;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.reviewerName,
    this.reviewerImage,
    required this.rating,
    required this.body,
    required this.createdAt,
  });

  // TODO(backend): wire to real doctor reviews endpoint when available
  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json['id'] as int,
        reviewerName: json['reviewer_name'] as String,
        reviewerImage: json['reviewer_image'] as String?,
        rating: json['rating'] as int,
        body: json['body'] as String,
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
      );
}
