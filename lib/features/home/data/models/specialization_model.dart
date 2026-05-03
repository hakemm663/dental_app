class SpecializationModel {
  final int id;
  final String name;
  final String? description;

  const SpecializationModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory SpecializationModel.fromJson(Map<String, dynamic> json) =>
      SpecializationModel(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String?,
      );
}
