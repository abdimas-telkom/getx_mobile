import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/models/question.dart'; // Import the Question model
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';
import '../../../routes/app_pages.dart';
import 'teacher_quiz_details_controller.dart';

class QuestionListController extends GetxController {
  // Keep a reference to the parent controller
  late final TeacherQuizDetailsController _parent;

  // Use a strongly-typed list of Question objects
  final questions = <Question>[].obs;

  // A getter to safely access the quizId from the parent
  int get quizId => _parent.quizId;

  @override
  void onInit() {
    super.onInit();
    _parent = Get.find<TeacherQuizDetailsController>();

    // Initialize the list of questions directly from the parent's Quiz object
    questions.assignAll(_parent.quizData.value?.questions ?? []);

    // Reactively update the local question list whenever the parent's quizData changes.
    // This removes the need for manual refresh calls.
    ever(_parent.quizData, (quiz) {
      questions.assignAll(quiz?.questions ?? []);
    });
  }

  /// Navigates to the edit screen, passing the strongly-typed Question object.
  Future<void> editQuestion(Question question) async {
    // The arguments passed to the next route are now type-safe
    final result = await Get.toNamed(
      Routes.TEACHER_QUIZ_EDIT,
      arguments: {'quizId': quizId, 'questionData': question},
    );

    // If the edit screen returns a success flag, reload the quiz details
    // in the parent controller. The `ever` listener will handle the UI update.
    if (result == true) {
      _parent.loadQuizDetails();
    }
  }

  /// Deletes a question using its ID from the Question object.
  Future<void> deleteQuestion(Question question) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus Pertanyaan'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus pertanyaan ini? Aksi ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('HAPUS', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await TeacherQuizService.deleteQuestion(quizId, question.id);
      Get.snackbar(
        'Sukses',
        'Pertanyaan berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Simply reload the parent's data. The reactive `ever` listener
      // will automatically update this controller's `questions` list.
      _parent.loadQuizDetails();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus pertanyaan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
