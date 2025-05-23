import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

import '../../../routes/app_pages.dart';
import 'teacher_quiz_details_controller.dart';

class QuestionListController extends GetxController {
  late final TeacherQuizDetailsController parent;
  final questions = <dynamic>[].obs;
  final quizId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    parent = Get.find<TeacherQuizDetailsController>();
    quizId.value = parent.quizId;
    questions.assignAll(parent.questions.cast<Map<String, dynamic>>());
    ever<List<dynamic>>(parent.questions, (newList) {
      questions.assignAll(
        newList.map((e) => Map<String, dynamic>.from(e as Map)),
      );
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> editQuestion(int quizId, Map<String, dynamic> question) async {
    await Get.toNamed(
      Routes.TEACHER_QUIZ_EDIT,
      arguments: {'quizId': quizId, 'questionData': question},
    );
    parent.loadQuizDetails();
    _refreshFromParent();
  }

  Future<void> deleteQuestion(int quizId, Map<String, dynamic> question) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Question'),
        content: const Text(
          'Are you sure you want to delete this question? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await TeacherQuizService.deleteQuestion(quizId, question['id']);
      Get.snackbar(
        'Success',
        'Question deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      _refreshFromParent();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error deleting question: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      parent.loadQuizDetails();
      _refreshFromParent();
    }
  }

  void _refreshFromParent() {
    questions.assignAll(parent.questions.cast<Map<String, dynamic>>());
  }
}
