import 'package:dio/dio.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://40.65.153.112:8080/api',
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  static void addAuthHeader(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static Dio get instance => _dio;
}
