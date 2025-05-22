import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

class AuthService {
  static const _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    ApiClient.addAuthHeader(token);
  }

  static Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token != null) ApiClient.addAuthHeader(token);
    return token;
  }

  static Future<void> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    final resp = await ApiClient.instance.post(
      '/register',
      data: {'name': name, 'email': email, 'password': password, 'role': role},
    );
    final token = resp.data['token'] as String;
    await saveToken(token);
  }

  static Future<void> login(String email, String password) async {
    final resp = await ApiClient.instance.post(
      '/login',
      data: {'email': email, 'password': password},
    );
    final token = resp.data['token'] as String;
    await saveToken(token);
  }

  static Future<void> logout() async {
    await ApiClient.instance.post('/logout');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    ApiClient.addAuthHeader('');
  }
}
