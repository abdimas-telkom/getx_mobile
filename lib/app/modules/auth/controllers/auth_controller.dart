import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/services/auth_service.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final obscurePassword = true.obs;
  final rememberMe = false.obs;

  final isLogin = true.obs;
  final selectedRole = 'student'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkToken();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> _checkToken() async {
    isLoading.value = true;
    final token = await AuthService.loadToken();
    if (token != null) _navigateBasedOnRole();
    isLoading.value = false;
  }

  Future<void> _navigateBasedOnRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString(AuthService.roleKey) ?? 'student';
    if (role == 'teacher') {
      Get.offAllNamed(Routes.TEACHER_DASHBOARD);
    } else {
      Get.offAllNamed(Routes.STUDENT_DASHBOARD);
    }
  }

  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
  }

  Future<void> handleAuth() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Terjadi Kesalahan', 'Tolong isi email dan password');
      return;
    }
    if (!isLogin.value && nameController.text.isEmpty) {
      Get.snackbar('Terjadi Kesalahan', 'Tolong isi nama anda');
      return;
    }
    isLoading.value = true;
    try {
      Map<String, dynamic> response;
      if (isLogin.value) {
        response = await AuthService.login(
          emailController.text,
          passwordController.text,
          rememberMe.value,
        );
      } else {
        response = await AuthService.register(
          nameController.text,
          emailController.text,
          passwordController.text,
          selectedRole.value,
        );
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AuthService.nameKey, response['user']['name']);
      await prefs.setString(AuthService.roleKey, response['user']['role']);
      _navigateBasedOnRole();
    } catch (e) {
      Get.snackbar('Terjadi Kesalahan', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
