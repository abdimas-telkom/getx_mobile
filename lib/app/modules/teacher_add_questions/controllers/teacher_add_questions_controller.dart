import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

class TeacherAddQuestionsController extends GetxController {
  final int quizId;
  final String quizTitle;
  final String quizCode;
  TeacherAddQuestionsController({
    required this.quizId,
    required this.quizTitle,
    required this.quizCode,
  });

  final questionText = ''.obs;
  final answers = <Map<String, dynamic>>[].obs;
  final correctIndex = 0.obs;
  final isLoading = false.obs;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initAnswers();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _initAnswers() {
    answers.assignAll([
      {'answer_text': '', 'is_correct': true},
      {'answer_text': '', 'is_correct': false},
    ]);
  }

  void addOption() {
    answers.add({'answer_text': '', 'is_correct': false});
  }

  void removeOption(int i) {
    if (answers.length > 2) answers.removeAt(i);
  }

  void selectCorrect(int i) {
    correctIndex.value = i;
    for (var j = 0; j < answers.length; j++) answers[j]['is_correct'] = j == i;
  }

  Future<void> saveQuestion() async {
    if (questionText.value.trim().isEmpty) return;
    isLoading.value = true;
    try {
      await TeacherQuizService.addQuestion(quizId, questionText.value, answers);
      count.value++;
      questionText.value = '';
      _initAnswers();
      correctIndex.value = 0;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void finish() {
    if (count.value == 0) return;
    Get.back(result: true);
  }
}
