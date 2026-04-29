import 'package:json_annotation/json_annotation.dart';

part 'city_model.g.dart';

@JsonSerializable()
class CityModel {
  final int id;
  final String name;
  @JsonKey(name: 'governorate_id')
  final int governorateId;

  CityModel({
    required this.id,
    required this.name,
    required this.governorateId,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}
