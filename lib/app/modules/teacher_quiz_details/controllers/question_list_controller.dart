import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/models/question.dart'; // Import the Question model
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';
import '../../../routes/app_pages.dart';
import 'teacher_quiz_details_controller.dart';

class QuestionListController extends GetxController {
  late final TeacherQuizDetailsController _parent;

  final questions = <Question>[].obs;

  int get quizId => _parent.quizId;

  @override
  void onInit() {
    super.onInit();
    _parent = Get.find<TeacherQuizDetailsController>();

    questions.assignAll(_parent.quizData.value?.questions ?? []);
    ever(_parent.quizData, (quiz) {
      questions.assignAll(quiz?.questions ?? []);
    });
  }

  Future<void> editQuestion(Question question) async {
    final result = await Get.toNamed(
      Routes.TEACHER_QUIZ_EDIT,
      arguments: {'quizId': quizId, 'questionData': question},
    );

    if (result == true) {
      _parent.loadQuizDetails();
    }
  }

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
