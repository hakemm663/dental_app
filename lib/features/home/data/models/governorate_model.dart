class GovernorateModel {
  final int id;
  final String name;

  const GovernorateModel({required this.id, required this.name});

  factory GovernorateModel.fromJson(Map<String, dynamic> json) =>
      GovernorateModel(id: json['id'] as int, name: json['name'] as String);
}
