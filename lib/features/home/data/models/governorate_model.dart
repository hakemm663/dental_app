import 'package:json_annotation/json_annotation.dart';

part 'governorate_model.g.dart';

@JsonSerializable()
class GovernorateModel {
  final int id;
  final String name;

  GovernorateModel({required this.id, required this.name});

  factory GovernorateModel.fromJson(Map<String, dynamic> json) =>
      _$GovernorateModelFromJson(json);

  Map<String, dynamic> toJson() => _$GovernorateModelToJson(this);
}
