import 'package:flutter/material.dart';
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

  bool get hasUnsavedChanges =>
      questionText.value.trim().isNotEmpty ||
      count.value == 0 &&
          answers.any((a) => (a['answer_text'] as String).isNotEmpty);

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
    if (answers.length <= 2) {
      Get.snackbar(
        'Cannot remove',
        'A question must have at least two options.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    answers.removeAt(i);
    if (correctIndex.value == i) {
      correctIndex.value = 0;
    } else if (correctIndex.value > i) {
      correctIndex.value--;
    }
  }

  void selectCorrect(int i) {
    correctIndex.value = i;
    for (var j = 0; j < answers.length; j++) {
      answers[j]['is_correct'] = j == i;
    }
    answers.refresh();
  }

  Future<void> saveQuestion() async {
    if (questionText.value.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Please enter a question.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (answers.any((a) => (a['answer_text'] as String).trim().isEmpty)) {
      Get.snackbar(
        'Validation',
        'Please fill all answer fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    isLoading.value = true;
    try {
      await TeacherQuizService.addQuestion(quizId, questionText.value, answers);
      count.value++;
      // reset form
      questionText.value = '';
      _initAnswers();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> confirmCancel() async {
    if (count.value > 0 || hasUnsavedChanges) {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Cancel Quiz Creation?'),
          content: Text(
            count.value > 0
                ? 'You have added ${count.value} questions. Going back will keep them but quiz remains unpublished.'
                : 'You have unsaved changes. Going back will discard this quiz.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('CONTINUE EDITING'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text(count.value > 0 ? 'GO BACK' : 'DISCARD & DELETE'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }

  Future<void> finishQuiz() async {
    // offer to save current question if unsaved
    if (hasUnsavedChanges) {
      final shouldSave = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Save Current Question?'),
          content: const Text(
            'You have an unsaved question. Save before finishing?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('YES'),
            ),
          ],
        ),
      );
      if (shouldSave == true) {
        await saveQuestion();
        if (hasUnsavedChanges) return; // abort if still unsaved
      }
    }
    if (count.value == 0) {
      Get.snackbar(
        'No Questions',
        'Please add at least one question before finishing.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.back(result: true);
  }
}
