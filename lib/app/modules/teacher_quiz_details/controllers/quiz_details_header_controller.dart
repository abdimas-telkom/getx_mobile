import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizDetailsHeaderController extends GetxController {
  final quizData = Rx<Map<String, dynamic>>({});
  final isEditing = false.obs;
  final isUpdating = false.obs;

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController codeController;

  @override
  void onInit() {
    super.onInit();
    final data = Get.arguments as Map<String, dynamic>;
    quizData.value = data;
    titleController = TextEditingController(text: data['title']);
    descriptionController = TextEditingController(text: data['description']);
    codeController = TextEditingController(text: data['code']);
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

  Future<void> saveChanges() async {
    isUpdating.value = true;
    final updated = {
      ...quizData.value,
      'title': titleController.text,
      'description': descriptionController.text,
      'code': codeController.text,
    };
    // call parent's onUpdate via Get.back or event
    Get.back(result: updated);
    isUpdating.value = false;
    isEditing.value = false;
  }
}
