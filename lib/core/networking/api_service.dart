import 'package:dio/dio.dart';
import 'package:docdoc/core/networking/api_constans.dart';
import 'package:docdoc/features/login/data/models/login_request_body.dart';
import 'package:docdoc/features/login/data/models/login_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstans.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
  @POST(ApiConstans.login)
  Future<LoginResponse> login(@Body() LoginRequestBody loginRequestBody);
}
