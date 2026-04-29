import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class DoctorModel {
  final int id;
  final String name;
  final String? image;
  final String? phone;
  final String? email;
  @JsonKey(name: 'specialization_id')
  final int? specializationId;
  @JsonKey(name: 'governorate_id')
  final int? governorateId;
  @JsonKey(name: 'city_id')
  final int? cityId;
  final String? address;
  final String? bio;
  @JsonKey(name: 'start_time')
  final String? startTime;
  @JsonKey(name: 'end_time')
  final String? endTime;
  final double? fees;
  final double? rating;

  DoctorModel({
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

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
