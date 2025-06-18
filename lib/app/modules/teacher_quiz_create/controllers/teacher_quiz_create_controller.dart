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
    if (title.value.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Please enter a title',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (timeLimit.value != null && timeLimit.value! < 10) {
      Get.snackbar(
        'Validation',
        'Durasi ujian minimal 10 menit',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
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
      final quizId = quiz['id'] as int;
      final quizTitle = quiz['title'] as String;
      final quizCode = quiz['code'] as String;

      // Navigate to add questions and await result
      final added =
          await Get.toNamed(
                Routes.TEACHER_ADD_QUESTIONS,
                arguments: {
                  'quizId': quizId,
                  'quizTitle': quizTitle,
                  'quizCode': quizCode,
                },
              )
              as bool?;

      if (added != true) {
        // No questions added: delete quiz
        try {
          await TeacherQuizService.deleteQuiz(quizId);
          Get.snackbar(
            'Canceled',
            'Quiz canceled: no questions were added.',
            snackPosition: SnackPosition.BOTTOM,
          );
        } catch (e) {
          Get.snackbar(
            'Error',
            'Error deleting empty quiz: ${e.toString()}',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        isLoading.value = false;
        return;
      }

      // Success
      Get.snackbar(
        'Success',
        'Quiz created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Go back, signaling success
      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
