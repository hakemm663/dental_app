import 'package:docdoc/features/home/data/models/doctor_experience_model.dart';

class DoctorModel {
  final int id;
  final String name;
  final String? image;
  final String? phone;
  final String? email;
  final int? specializationId;
  final String? specializationName;
  final int? governorateId;
  final int? cityId;
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
    this.specializationId,
    this.specializationName,
    this.governorateId,
    this.cityId,
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

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final expList = json['experiences'] as List?;
    return DoctorModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      specializationId: json['specialization_id'] as int?,
      specializationName: json['specialization_name'] as String? ??
          (json['specialization'] as Map<String, dynamic>?)?['name'] as String?,
      governorateId: json['governorate_id'] as int?,
      cityId: json['city_id'] as int?,
      address: json['address'] as String?,
      bio: json['bio'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      fees: (json['fees'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewsCount: json['reviews_count'] as int?,
      str: json['str'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      experiences: expList
          ?.map((e) =>
              DoctorExperienceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
