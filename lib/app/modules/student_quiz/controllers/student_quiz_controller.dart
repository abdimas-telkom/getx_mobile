import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/services/student_quiz_service.dart';

class StudentQuizController extends GetxController {
  final int quizId;
  StudentQuizController({required this.quizId});

  var questions = <dynamic>[].obs;
  var currentIndex = 0.obs;
  var userAnswers = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadQuestions() async {
    isLoading.value = true;
    try {
      final data = await StudentQuizService.getQuestions(quizId);
      questions.assignAll(data);
      userAnswers.assignAll(
        List.generate(data.length, (_) => {'question_id': 0, 'answer_id': 0}),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectAnswer(int id) {
    userAnswers[currentIndex.value] = {
      'question_id': questions[currentIndex.value]['id'],
      'answer_id': id,
    };
    userAnswers.refresh();
  }

  void next() {
    if (currentIndex.value < questions.length - 1)
      currentIndex.value++;
    else
      submit();
  }

  void previous() {
    if (currentIndex.value > 0) currentIndex.value--;
  }

  Future<void> submit() async {
    for (var i = 0; i < userAnswers.length; i++) {
      if (userAnswers[i]['answer_id'] == 0) {
        Get.snackbar('Incomplete', 'Answer question ${i + 1}');
        currentIndex.value = i;
        return;
      }
    }
    isSubmitting.value = true;
    try {
      final res = await StudentQuizService.submitAnswers(quizId, userAnswers);
      Get.offNamed(Routes.STUDENT_RESULT, arguments: res['attempt_id']);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
}
