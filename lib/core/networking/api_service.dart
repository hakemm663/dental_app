import 'package:dio/dio.dart';
import 'package:docdoc/core/networking/api_constans.dart';
import 'package:docdoc/features/login/data/models/login_request_body.dart';
import 'package:docdoc/features/login/data/models/login_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstans.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
  
  // Auth
  @POST(ApiConstans.login)
  Future<LoginResponse> login(@Body() LoginRequestBody loginRequestBody);
  
  // Home
  @GET('/home/index')
  Future<Map<String, dynamic>> getHomeData();
  
  // Governorate
  @GET('/governrate/index')
  Future<Map<String, dynamic>> getAllGovernrates();
  
  // City
  @GET('/city/index')
  Future<Map<String, dynamic>> getAllCities();
  
  @GET('/city/show/{governorateId}')
  Future<Map<String, dynamic>> getCitiesByGovernorate(
    @Path('governorateId') int governorateId,
  );
  
  // Specialization
  @GET('/specialization/index')
  Future<Map<String, dynamic>> getAllSpecializations();
  
  @GET('/specialization/show/{id}')
  Future<Map<String, dynamic>> getSpecialization(@Path('id') int id);
  
  // Doctor
  @GET('/doctor/index')
  Future<Map<String, dynamic>> getAllDoctors();
  
  @GET('/doctor/show/{id}')
  Future<Map<String, dynamic>> getDoctorDetails(@Path('id') int id);
  
  @GET('/doctor/doctor-filter')
  Future<Map<String, dynamic>> filterDoctors(
    @Query('city') int? cityId,
    @Query('specialization') int? specializationId,
  );
  
  @GET('/doctor/doctor-search')
  Future<Map<String, dynamic>> searchDoctors(@Query('name') String name);
  
  // User
  @GET('/user/profile')
  Future<Map<String, dynamic>> getUserProfile();
  
  @POST('/user/update')
  Future<Map<String, dynamic>> updateProfile(@Body() Map<String, dynamic> body);
  
  // Appointment
  @GET('/appointment/index')
  Future<Map<String, dynamic>> getAllAppointments();
  
  @POST('/appointment/store')
  Future<Map<String, dynamic>> createAppointment(
    @Body() Map<String, dynamic> body,
  );
}
