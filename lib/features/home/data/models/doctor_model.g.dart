// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  image: json['image'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  specializationId: (json['specialization_id'] as num?)?.toInt(),
  governorateId: (json['governorate_id'] as num?)?.toInt(),
  cityId: (json['city_id'] as num?)?.toInt(),
  address: json['address'] as String?,
  bio: json['bio'] as String?,
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
  fees: (json['fees'] as num?)?.toDouble(),
  rating: (json['rating'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'phone': instance.phone,
      'email': instance.email,
      'specialization_id': instance.specializationId,
      'governorate_id': instance.governorateId,
      'city_id': instance.cityId,
      'address': instance.address,
      'bio': instance.bio,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'fees': instance.fees,
      'rating': instance.rating,
    };
