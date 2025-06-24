import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _roleKey = 'user_role';
  static const String nameKey = 'user_name';

  static const String roleKey = _roleKey;

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

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    final resp = await ApiClient.instance.post(
      '/register',
      data: {'name': name, 'email': email, 'password': password, 'role': role},
    );
    final data = Map<String, dynamic>.from(resp.data);
    final token = data['token'] as String;
    await saveToken(token);
    return data;
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
    bool remember,
  ) async {
    final resp = await ApiClient.instance.post(
      '/login',
      data: {'email': email, 'password': password, 'remember': remember},
    );
    final data = Map<String, dynamic>.from(resp.data);
    final token = data['token'] as String;
    await saveToken(token);
    return data;
  }

  static Future<void> logout() async {
    await ApiClient.instance.post('/logout');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_roleKey);
    ApiClient.addAuthHeader('');
  }
}
