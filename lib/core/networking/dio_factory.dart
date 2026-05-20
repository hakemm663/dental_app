import 'package:dio/dio.dart';
import 'package:docdoc/core/helpers/constans.dart';
import 'package:docdoc/core/helpers/shared_pref_helper.dart';
import 'package:docdoc/core/networking/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  DioFactory._();

  static Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(_TokenInterceptor());

    // Request/response logging is a development-only convenience. In release
    // builds it would write request bodies and headers — including login
    // credentials and bearer tokens — into device logs.
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseHeader: false,
        ),
      );
    }

    return dio;
  }

  static void updateToken(Dio dio, String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static void clearToken(Dio dio) {
    dio.options.headers.remove('Authorization');
  }
}

class _TokenInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
