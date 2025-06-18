import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import '../controllers/teacher_quiz_details_controller.dart';
import 'question_list_view.dart';
import 'quiz_attempt_list_view.dart';
import 'quiz_details_header_view.dart';

class TeacherQuizDetailsView extends GetView<TeacherQuizDetailsController> {
  const TeacherQuizDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Ujian',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: whiteColor,
        foregroundColor: blackColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          Obx(
            () => controller.isDeleting.value
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    onPressed: controller.deleteQuiz,
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete Quiz',
                  ),
          ),
        ],
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: textMutedColor,
          tabs: const [
            Tab(text: 'Detail'),
            Tab(text: 'Soal'),
            Tab(text: 'Percobaan'),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () =>
            controller.currentTab.value ==
                1 // Only show on 'Soal' tab
            ? FloatingActionButton(
                onPressed: controller.addQuestion,
                backgroundColor: primaryColor,
                foregroundColor: whiteColor,
                child: const Icon(Icons.add),
              )
            : const SizedBox.shrink(),
      ),
      body: Obx(() {
        if (controller.isLoadingInfo.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.quizData.value == null) {
          return const Center(child: Text('Gagal memuat detail ujian'));
        }
        // The fix is applied inside the TabBarView's children list
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: TabBarView(
            controller: controller.tabController,
            children: const [
              // --- FIX IS HERE ---
              // Wrap the first tab's content in an Align widget.
              // This allows it to take its natural height ("hug content")
              // instead of being stretched by the TabBarView.
              Align(
                alignment: Alignment.topCenter,
                child: QuizDetailsHeaderView(),
              ),

              // The other list-based tabs should NOT be wrapped,
              // as they need to fill the space to be scrollable.
              QuestionListView(),
              QuizAttemptListView(),
            ],
          ),
        );
      }),
    );
  }
}
