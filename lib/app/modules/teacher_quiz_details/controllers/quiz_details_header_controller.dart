import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'teacher_quiz_details_controller.dart';

class QuizDetailsHeaderController extends GetxController {
  final quizData = Rx<Map<String, dynamic>>({
    'title': '',
    'description': '',
    'code': '',
    'is_active': false,
    'time_limit': 0,
  });
  final isEditing = false.obs;
  final isUpdating = false.obs;

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController codeController;

  @override
  void onInit() {
    super.onInit();
    final parent = Get.find<TeacherQuizDetailsController>();
    final data = parent.quizData.value ?? {};
    quizData.value = {
      'title': data['title'] ?? '',
      'description': data['description'] ?? '',
      'code': data['code'] ?? '',
      'is_active': data['is_active'] ?? false,
      'time_limit': data['time_limit'] ?? 0,
    };

    titleController = TextEditingController(text: quizData.value['title']);
    descriptionController = TextEditingController(
      text: quizData.value['description'],
    );
    codeController = TextEditingController(text: quizData.value['code']);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    codeController.dispose();
    super.onClose();
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }

  void updateActiveStatus(bool active) {
    quizData.update((val) {
      val?['is_active'] = active;
    });
  }

  void updateTimeLimit(String value) {
    final minutes = int.tryParse(value) ?? 0;
    quizData.update((val) {
      val?['time_limit'] = minutes;
    });
  }

  Future<void> saveChanges() async {
    isUpdating.value = true;

    final updated = {
      'title': titleController.text,
      'description': descriptionController.text,
      'code': codeController.text,
      'is_active': quizData.value['is_active'],
      'time_limit': quizData.value['time_limit'],
    };

    // Call parent update
    final parent = Get.find<TeacherQuizDetailsController>();
    await parent.updateQuizDetails({
      'title': updated['title'],
      'description': updated['description'],
      'code': updated['code'],
      'is_active': updated['is_active'],
      'time_limit': updated['time_limit'],
    });

    // Reflect updated data locally
    quizData.value = updated;
    isUpdating.value = false;
    isEditing.value = false;
  }
}
