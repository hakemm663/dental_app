import 'package:dio/dio.dart';
import 'api_error_model.dart';

class ApiErrorHandler {
  static String handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    return 'An unexpected error occurred';
  }

  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out. Please try again.';
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badCertificate:
        return 'SSL certificate error.';
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return 'No internet connection.';
        }
        return 'An unexpected error occurred.';
    }
  }

  static String _handleBadResponse(Response? response) {
    if (response == null) return 'Server error.';
    try {
      final model = ApiErrorModel.fromJson(response.data as Map<String, dynamic>);
      return model.message ?? 'Server error (${response.statusCode}).';
    } catch (_) {
      return 'Server error (${response.statusCode}).';
    }
  }
}
