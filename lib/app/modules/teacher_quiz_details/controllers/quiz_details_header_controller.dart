import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/models/quiz.dart';
import 'teacher_quiz_details_controller.dart';

class QuizDetailsHeaderController extends GetxController {
  final isEditing = false.obs;
  final isUpdating = false.obs;
  final isActiveForEditing = false.obs;

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController codeController;
  late TextEditingController timeLimitController;

  late final TeacherQuizDetailsController _parentController;

  @override
  void onInit() {
    super.onInit();
    _parentController = Get.find<TeacherQuizDetailsController>();

    titleController = TextEditingController();
    descriptionController = TextEditingController();
    codeController = TextEditingController();
    timeLimitController = TextEditingController();

    _initializeFields(_parentController.quizData.value);

    ever(_parentController.quizData, (Quiz? newQuizData) {
      if (!isEditing.value) {
        _initializeFields(newQuizData);
      }
    });
  }

  void _initializeFields(Quiz? quiz) {
    if (quiz == null) return;
    titleController.text = quiz.title;
    descriptionController.text = quiz.description ?? '';
    codeController.text = quiz.code;
    timeLimitController.text = (quiz.timeLimit ?? 0).toString();
    isActiveForEditing.value = quiz.isActive;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    codeController.dispose();
    timeLimitController.dispose();
    super.onClose();
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      _initializeFields(_parentController.quizData.value);
    }
  }

  Future<void> saveChanges() async {
    isUpdating.value = true;
    final updatedData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'code': codeController.text,
      'is_active': isActiveForEditing.value,
      'time_limit': int.tryParse(timeLimitController.text) ?? 0,
    };

    try {
      await _parentController.updateQuizDetails(updatedData);
      isEditing.value = false;
    } catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        'Gagal menyimpan perubahan. Silakan coba lagi.',
      );
    } finally {
      isUpdating.value = false;
    }
  }
}
