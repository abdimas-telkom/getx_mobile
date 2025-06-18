import 'package:dio/dio.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.3:8000/api',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static void addAuthHeader(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static Dio get instance => _dio;
}
