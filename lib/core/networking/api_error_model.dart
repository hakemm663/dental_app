class ApiErrorModel {
  final String? message;
  final int? code;

  const ApiErrorModel({this.message, this.code});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) => ApiErrorModel(
        message: json['message'] as String?,
        code: json['code'] as int?,
      );
}
