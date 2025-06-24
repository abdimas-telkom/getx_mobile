import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/app/modules/teacher_dashboard/controllers/teacher_dashboard_controller.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

class TeacherQuizCreateController extends GetxController {
  final title = ''.obs;
  final description = ''.obs;
  final code = ''.obs;
  final isActive = false.obs;
  final useCustom = false.obs;
  final timeLimit = Rxn<int>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    var parent = Get.find<TeacherDashboardController>();
    parent.loadQuizzes();
  }

  Future<void> submit() async {
    if (title.value.trim().isEmpty) {
      Get.snackbar(
        'Terjadi Kesalahan',
        'Tolong isi judul',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (timeLimit.value != null && timeLimit.value! < 10) {
      Get.snackbar(
        'Terjadi Kesalahan',
        'Durasi ujian minimal 10 menit',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    isLoading.value = true;
    try {
      final resp = await TeacherQuizService.createQuiz(
        title: title.value,
        description: description.value,
        code: useCustom.value ? code.value : null,
        isActive: isActive.value,
        timeLimit: timeLimit.value,
      );
      final quiz = resp['quiz'] as Map<String, dynamic>;
      final quizId = quiz['id'] as int;
      final quizTitle = quiz['title'] as String;
      final quizCode = quiz['code'] as String;

      final added =
          await Get.toNamed(
                Routes.TEACHER_ADD_QUESTIONS,
                arguments: {
                  'quizId': quizId,
                  'quizTitle': quizTitle,
                  'quizCode': quizCode,
                  'questionCount': 0,
                  'isNewQuiz': true,
                },
              )
              as bool?;

      navigation(quizId, added!);

      Get.snackbar(
        'Berhasil!',
        'Ujian berhasil dibuat!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (e.toString().contains('404')) {
        Get.snackbar(
          'Terjadi Kesalahan',
          'Server tidak ditemukan. Pastikan server berjalan.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.toString().contains('500')) {
        Get.snackbar(
          'Terjadi Kesalahan',
          'Kesalahan server. Silakan coba lagi nanti.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.toString().contains('400')) {
        Get.snackbar(
          'Terjadi Kesalahan',
          'Permintaan tidak valid. Periksa data yang dimasukkan.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> navigation(int quizId, bool added) async {
    if (added != true) {
      try {
        await TeacherQuizService.deleteQuiz(quizId);
        Get.snackbar(
          'Dibatalkan',
          'Ujian dibatalkan: tidak ada pertanyaan yang ditambahkan.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'Terjadi Kesalahan',
          'Gagal menghapus ujian kosong: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      isLoading.value = false;
      return;
    }
    return;
  }
}
