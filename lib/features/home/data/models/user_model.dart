class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int gender;
  final String? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        gender: json['gender'] as int,
        createdAt: json['created_at'] as String?,
      );
}
