import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/models/quiz_attempt.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

class TeacherQuizDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final int quizId;
  TeacherQuizDetailsController({required this.quizId});

  var quizData = Rxn<Map<String, dynamic>>();
  var questions = <dynamic>[].obs;
  var attempts = <QuizAttempt>[].obs;
  var isLoadingInfo = false.obs;
  var isLoadingAttempts = false.obs;
  var isDeleting = false.obs;
  var currentTab = 0.obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging)
        currentTab.value = tabController.index;
    });
    loadQuizDetails();
    loadAttempts();
  }

  Future<void> loadQuizDetails() async {
    isLoadingInfo.value = true;
    try {
      final data = await TeacherQuizService.getQuizDetails(quizId);
      quizData.value = data;
      questions.assignAll(data['questions'] ?? []);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingInfo.value = false;
    }
  }

  Future<void> loadAttempts() async {
    isLoadingAttempts.value = true;
    try {
      final list = await TeacherQuizService.getQuizAttempts(quizId);
      attempts.assignAll(list as Iterable<QuizAttempt>);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingAttempts.value = false;
    }
  }

  Future<void> deleteQuiz() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Quiz'),
        content: const Text(
          'Are you sure you want to delete this quiz? This action cannot be undone.',
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
    if (confirm != true) return;
    isDeleting.value = true;
    try {
      await TeacherQuizService.deleteQuiz(quizId);
      Get.back(result: true);
      Get.snackbar(
        'Success',
        'Quiz deleted',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> toggleStatus() async {
    try {
      await TeacherQuizService.toggleStatus(quizId);
      await loadQuizDetails();
      final active = quizData.value?['is_active'] == true;
      Get.snackbar(
        'Status Updated',
        active ? 'Activated' : 'Deactivated',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void addQuestion() async {
    final res = await Get.toNamed(
      Routes.TEACHER_ADD_QUESTIONS,
      arguments: {
        'quizId': quizId,
        'quizTitle': quizData.value?['title'],
        'quizCode': quizData.value?['code'],
      },
    );
    if (res == true) loadQuizDetails();
  }
}
