import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

class TeacherQuizCreateController extends GetxController {
  final title = ''.obs;
  final description = ''.obs;
  final code = ''.obs;
  final isActive = false.obs;
  final useCustom = false.obs;
  final timeLimit = Rxn<int>();
  final isLoading = false.obs;

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
    super.onClose();
  }

  Future<void> submit() async {
    if (title.value.trim().isEmpty) return;
    isLoading.value = true;
    try {
      final resp = await TeacherQuizService.createQuiz(
        title: title.value,
        description: description.value,
        code: useCustom.value ? code.value : null,
        isActive: isActive.value,
        timeLimit: timeLimit.value,
      );
      final quiz = resp['quiz'] as Map<String, dynamic>;
      Get.toNamed(
        Routes.TEACHER_ADD_QUESTIONS,
        arguments: {
          'quizId': quiz['id'],
          'quizTitle': quiz['title'],
          'quizCode': quiz['code'],
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
