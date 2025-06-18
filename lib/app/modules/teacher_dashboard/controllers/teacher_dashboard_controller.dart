import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/services/auth_service.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

class TeacherDashboardController extends GetxController {
  var quizzes = <dynamic>[].obs;
  var isLoading = false.obs;
  final teacherName = 'Alvan'.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuizzes();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadQuizzes() async {
    isLoading.value = true;
    try {
      quizzes.assignAll(await TeacherQuizService.getQuizzes());
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    try {
      await AuthService.logout();
      Get.offAllNamed(Routes.AUTH);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void createNewQuiz() async {
    final result = await Get.toNamed(Routes.TEACHER_QUIZ_CREATE);
    if (result == true) loadQuizzes();
  }

  void viewQuizDetails(int quizId) async {
    final result = await Get.toNamed(
      Routes.TEACHER_QUIZ_DETAILS,
      arguments: quizId,
    );
    if (result == true) loadQuizzes();
  }
}
