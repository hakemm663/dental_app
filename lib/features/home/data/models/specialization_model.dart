import 'package:json_annotation/json_annotation.dart';

part 'specialization_model.g.dart';

@JsonSerializable()
class SpecializationModel {
  final int id;
  final String name;
  final String? description;

  SpecializationModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory SpecializationModel.fromJson(Map<String, dynamic> json) =>
      _$SpecializationModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpecializationModelToJson(this);
}
