class LoginResponse {
  String? message;
  UserData? userData;
  bool? status;
  int? code;

  LoginResponse({this.message, this.userData, this.status, this.code});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        message: json['message'],
        userData: json['data'] == null ? null : UserData.fromJson(json['data']),
        status: json['status'],
        code: json['code'],
      );
}

class UserData {
  String? token;
  String? userName;

  UserData({this.token, this.userName});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        token: json['token'],
        userName: json['username'],
      );
}
