import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/services/student_quiz_service.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

class StudentResultController extends GetxController {
  final int attemptId;
  final bool isGuru;
  StudentResultController({required this.attemptId, required this.isGuru});

  var results = Rxn<Map<String, dynamic>>();
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    loadResults();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadResults() async {
    isLoading.value = true;
    try {
      results.value = await StudentQuizService.getResults(attemptId);
    } catch (e) {
      if (isGuru && e.toString().contains('403')) {
        results.value = await TeacherQuizService.getResults(attemptId);
      } else {
        Get.snackbar(
          'Terjadi Kesalahan',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void backHome() {
    if (isGuru) {
      Get.back();
    } else {
      Get.offAllNamed(Routes.STUDENT_DASHBOARD);
    }
  }
}
