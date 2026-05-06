class CityModel {
  final int id;
  final String name;
  final int governorateId;
  final String? governorateName;

  const CityModel({
    required this.id,
    required this.name,
    required this.governorateId,
    this.governorateName,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    final gov = json['governrate'] as Map<String, dynamic>?;
    return CityModel(
      id: json['id'] as int,
      name: json['name'] as String,
      governorateId: gov?['id'] as int? ?? json['governorate_id'] as int,
      governorateName: gov?['name'] as String?,
    );
  }
}
