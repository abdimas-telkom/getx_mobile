import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/teacher_quiz_details_controller.dart';
import 'question_list_view.dart';
import 'quiz_attempt_list_view.dart';
import 'quiz_details_header_view.dart';

class TeacherQuizDetailsView extends GetView<TeacherQuizDetailsController> {
  const TeacherQuizDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(c.quizData.value?['title'] ?? 'Quiz')),
        actions: [
          Obx(
            () => c.isDeleting.value
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: c.deleteQuiz,
                    icon: const Icon(Icons.delete),
                  ),
          ),
          IconButton(
            onPressed: c.toggleStatus,
            icon: const Icon(Icons.toggle_on),
          ),
        ],
        bottom: TabBar(
          controller: c.tabController,
          tabs: const [
            Tab(text: 'Info'),
            Tab(text: 'Questions'),
            Tab(text: 'Attempts'),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => c.currentTab.value == 1
            ? FloatingActionButton(
                onPressed: c.addQuestion,
                child: const Icon(Icons.add),
              )
            : const SizedBox.shrink(),
      ),
      body: Obx(() {
        if (c.isLoadingInfo.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.quizData.value == null) {
          return const Center(child: Text('Failed to load quiz details'));
        }
        return TabBarView(
          controller: c.tabController,
          children: const [
            Padding(
              padding: EdgeInsets.all(16),
              child: QuizDetailsHeaderView(),
            ),
            Padding(padding: EdgeInsets.all(16), child: QuestionListView()),
            Padding(padding: EdgeInsets.all(16), child: QuizAttemptListView()),
          ],
        );
      }),
    );
  }
}
