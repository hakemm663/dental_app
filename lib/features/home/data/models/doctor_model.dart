class DoctorModel {
  final int id;
  final String name;
  final String? image;
  final String? phone;
  final String? email;
  final int? specializationId;
  final int? governorateId;
  final int? cityId;
  final String? address;
  final String? bio;
  final String? startTime;
  final String? endTime;
  final double? fees;
  final double? rating;

  const DoctorModel({
    required this.id,
    required this.name,
    this.image,
    this.phone,
    this.email,
    this.specializationId,
    this.governorateId,
    this.cityId,
    this.address,
    this.bio,
    this.startTime,
    this.endTime,
    this.fees,
    this.rating,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
        id: json['id'] as int,
        name: json['name'] as String,
        image: json['image'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        specializationId: json['specialization_id'] as int?,
        governorateId: json['governorate_id'] as int?,
        cityId: json['city_id'] as int?,
        address: json['address'] as String?,
        bio: json['bio'] as String?,
        startTime: json['start_time'] as String?,
        endTime: json['end_time'] as String?,
        fees: (json['fees'] as num?)?.toDouble(),
        rating: (json['rating'] as num?)?.toDouble(),
      );
}
