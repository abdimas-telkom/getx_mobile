import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/services/auth_service.dart';
import 'package:ujian_sd_babakan_ciparay/services/student_quiz_service.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';

class StudentDashboardController extends GetxController {
  final codeController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final studentName = 'Murid'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserName();
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

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    studentName.value = prefs.getString(AuthService.nameKey) ?? 'Siswa';
  }

  Future<void> joinQuiz() async {
    if (codeController.text.isEmpty) {
      errorMessage.value = 'Please enter a quiz code';
      return;
    }
    await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Masuk Ujian'),
        content: const Text(
          'Apakah Anda yakin ingin masuk ke ujian ini? Pastikan kode yang dimasukkan benar.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Kembali'),
          ),
          TextButton(
            onPressed: () async {
              isLoading.value = true;
              errorMessage.value = '';
              try {
                final quiz = await StudentQuizService.getQuizByCode(
                  codeController.text,
                );
                isLoading.value = false;
                Get.back();
                Get.offNamed(
                  Routes.STUDENT_QUIZ,
                  arguments: [quiz['quiz_id'], quiz['time_limit']],
                );
              } catch (e) {
                print(e.toString());
                if (e.toString().contains('403')) {
                  errorMessage.value = 'Anda sudah mengikuti ujian ini';
                } else if (e.toString().contains('400')) {
                  errorMessage.value = 'Kode ujian tidak valid';
                } else if (e.toString().contains('404')) {
                  errorMessage.value = 'Ujian tidak ditemukan';
                } else {
                  errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
                }
                isLoading.value = false;
                Get.back();
              }
            },
            child: const Text('Masuk', style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
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
