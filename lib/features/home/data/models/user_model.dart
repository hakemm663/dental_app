class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? gender;
  final String? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.gender,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawGender = json['gender'];
    return UserModel(
      id: json['id'].toString(),
      name: (json['full_name'] ?? json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phone: (json['phone'] ?? '') as String,
      gender: rawGender is int ? rawGender.toString() : rawGender as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}
