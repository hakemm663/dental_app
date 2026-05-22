import 'package:docdoc/features/home/data/models/doctor_experience_model.dart';

class DoctorModel {
  final int id;
  final String name;
  final String? image;
  final String? phone;
  final String? email;
  final String? gender;
  final String? degree;
  final int? specializationId;
  final String? specializationName;
  final int? governorateId;
  final String? governorateName;
  final int? cityId;
  final String? cityName;
  final String? address;
  final String? bio;
  final String? startTime;
  final String? endTime;
  final double? fees;
  final double? rating;
  final int? reviewsCount;
  final String? str;
  final double? latitude;
  final double? longitude;
  final List<DoctorExperienceModel>? experiences;

  const DoctorModel({
    required this.id,
    required this.name,
    this.image,
    this.phone,
    this.email,
    this.gender,
    this.degree,
    this.specializationId,
    this.specializationName,
    this.governorateId,
    this.governorateName,
    this.cityId,
    this.cityName,
    this.address,
    this.bio,
    this.startTime,
    this.endTime,
    this.fees,
    this.rating,
    this.reviewsCount,
    this.str,
    this.latitude,
    this.longitude,
    this.experiences,
  });

  /// Parses a `doctors` row from Supabase. Expects the embedded selects
  /// `specialization:specializations(...)`, `city:cities(...,governorate:...)`
  /// and `clinic:clinics(...)`.
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final spec = json['specialization'] as Map<String, dynamic>?;
    final city = json['city'] as Map<String, dynamic>?;
    final gov = city?['governorate'] as Map<String, dynamic>?;
    final clinic = json['clinic'] as Map<String, dynamic>?;

    return DoctorModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['photo_url'] as String?,
      phone: clinic?['phone'] as String?,
      gender: json['gender'] as String?,
      degree: json['title'] as String?,
      specializationId:
          spec?['id'] as int? ?? json['specialization_id'] as int?,
      specializationName: spec?['name'] as String?,
      governorateId: gov?['id'] as int?,
      governorateName: gov?['name'] as String?,
      cityId: city?['id'] as int? ?? json['city_id'] as int?,
      cityName: city?['name'] as String?,
      address: clinic?['address'] as String?,
      bio: json['bio'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      fees: (json['consultation_fee'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewsCount: json['reviews_count'] as int?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}
