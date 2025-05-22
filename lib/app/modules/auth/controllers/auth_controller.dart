import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/services/auth_service.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

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
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }
    if (!isLogin.value && nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return;
    }

    isLoading.value = true;
    try {
      Map<String, dynamic> response;
      if (isLogin.value) {
        response = await AuthService.login(
          emailController.text,
          passwordController.text,
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
      await prefs.setString(AuthService.roleKey, response['user']['role']);
      _navigateBasedOnRole();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
