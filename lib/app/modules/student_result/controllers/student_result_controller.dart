import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/services/student_quiz_service.dart';

class StudentResultController extends GetxController {
  final int attemptId;
  StudentResultController({required this.attemptId});

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
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void backHome() => Get.offAllNamed(Routes.STUDENT_DASHBOARD);
}
