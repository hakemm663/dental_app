class CityModel {
  final int id;
  final String name;
  final int governorateId;

  const CityModel({
    required this.id,
    required this.name,
    required this.governorateId,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json['id'] as int,
        name: json['name'] as String,
        governorateId: json['governorate_id'] as int,
      );
}
