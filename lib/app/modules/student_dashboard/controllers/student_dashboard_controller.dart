import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/services/auth_service.dart';
import 'package:ujian_sd_babakan_ciparay/services/student_quiz_service.dart';

class StudentDashboardController extends GetxController {
  final codeController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final studentName = 'Alvan'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  Future<void> joinQuiz() async {
    if (codeController.text.isEmpty) {
      errorMessage.value = 'Please enter a quiz code';
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final quiz = await StudentQuizService.getQuizByCode(codeController.text);
      isLoading.value = false;
      Get.offNamed(Routes.STUDENT_QUIZ, arguments: quiz['quiz_id']);
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString().contains('not found')
          ? 'Quiz not found or inactive'
          : e.toString();
    }
  }

  Future<void> logout() async {
    try {
      await AuthService.logout();
      Get.offAllNamed(Routes.AUTH);
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
}
