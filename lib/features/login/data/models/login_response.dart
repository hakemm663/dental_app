class LoginResponse {
  final String? message;
  final String? token;
  final String? username;
  final bool? status;
  final int? code;

  const LoginResponse({
    this.message,
    this.token,
    this.username,
    this.status,
    this.code,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return LoginResponse(
      message: json['message'] as String?,
      token: data?['token'] as String?,
      username: data?['username'] as String?,
      status: json['status'] as bool?,
      code: json['code'] as int?,
    );
  }
}
