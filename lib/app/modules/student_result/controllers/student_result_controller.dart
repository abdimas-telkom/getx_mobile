import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/models/quiz_result.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/services/student_quiz_service.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

class StudentResultController extends GetxController {
  final int attemptId;
  final bool isGuru;
  StudentResultController({required this.attemptId, required this.isGuru});

  var results = Rxn<QuizResult>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadResults();
  }

  Future<void> loadResults() async {
    isLoading.value = true;
    print(attemptId);
    try {
      results.value = await StudentQuizService.getResults(attemptId);
    } catch (e) {
      if (isGuru && e.toString().contains('403')) {
        try {
          results.value = await TeacherQuizService.getResults(attemptId);
        } catch (teacherError) {
          Get.snackbar(
            'Terjadi Kesalahan',
            'Gagal memuat hasil: $teacherError',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        print("Error loading results: $e");
        print(results.value);
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
