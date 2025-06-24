import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ujian_sd_babakan_ciparay/app/modules/teacher_dashboard/controllers/teacher_dashboard_controller.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/models/quiz.dart';
import 'package:ujian_sd_babakan_ciparay/models/quiz_attempt.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

class TeacherQuizDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final int quizId;
  TeacherQuizDetailsController({required this.quizId});

  var quizData = Rxn<Quiz>();
  var attempts = <QuizAttempt>[].obs;
  var isLoadingInfo = false.obs;
  var isLoadingAttempts = false.obs;
  var isDeleting = false.obs;
  final isExporting = false.obs;
  var currentTab = 0.obs;
  late TabController tabController;

  int get totalAttempts => attempts.length;
  int get completedAttempts =>
      attempts.where((a) => a.status == 'finished').length;
  double get averageScore {
    if (attempts.isEmpty || completedAttempts == 0) return 0.0;
    final completed = attempts.where((a) => a.status == 'finished');
    final totalScore = completed.map((a) => a.score).reduce((a, b) => a + b);
    return totalScore / completed.length;
  }

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

  @override
  void onClose() {
    tabController.dispose();
    final parent = Get.find<TeacherDashboardController>();
    parent.loadQuizzes();
    super.onClose();
  }

  Future<void> loadQuizDetails() async {
    isLoadingInfo.value = true;
    try {
      quizData.value = await TeacherQuizService.getQuizDetails(quizId);
    } catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingInfo.value = false;
    }
  }

  Future<void> loadAttempts() async {
    isLoadingAttempts.value = true;
    try {
      final list = await TeacherQuizService.getQuizAttempts(quizId);
      attempts.value = list;
    } catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingAttempts.value = false;
    }
  }

  Future<void> updateQuizDetails(Map<String, dynamic> updatedData) async {
    try {
      await TeacherQuizService.updateQuiz(quizId, updatedData);

      Get.snackbar(
        'Sukses',
        'Ujian berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadQuizDetails();
    } catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        'Gagal memperbarui ujian: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteQuiz() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus Ujian'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus ujian ini? Aksi ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    isDeleting.value = true;
    try {
      await TeacherQuizService.deleteQuiz(quizId);
      Get.offAllNamed(Routes.TEACHER_DASHBOARD);
      Get.snackbar(
        'Sukses',
        'Ujian berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> toggleStatus() async {
    try {
      await TeacherQuizService.toggleStatus(quizId);
      await loadQuizDetails();
      final active = quizData.value?.isActive == true;
      Get.snackbar(
        'Status Diperbarui',
        active ? 'Diaktifkan' : 'Dinonaktifkan',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void addQuestion() async {
    final res = await Get.toNamed(
      Routes.TEACHER_ADD_QUESTIONS,
      arguments: {
        'quizId': quizId,
        'quizTitle': quizData.value?.title,
        'quizCode': quizData.value?.code,
      },
    );
    if (res == true) loadQuizDetails();
  }

  Future<void> exportAttempts() async {
    if (isExporting.value) return;
    isExporting.value = true;
    try {
      final pdfBytes = await TeacherQuizService.exportAttemptsToPdf(quizId);

      final directory = await getApplicationDocumentsDirectory();

      final quizTitleSlug =
          quizData.value?.title.replaceAll(' ', '_') ?? 'quiz';
      final fileName =
          'Ringkasan_${quizTitleSlug}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      Get.snackbar(
        'Sukses',
        'PDF berhasil diunduh.',
        snackPosition: SnackPosition.BOTTOM,
      );

      await OpenFile.open(filePath);
    } catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        'Gagal mengekspor PDF: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isExporting.value = false;
    }
  }
}
