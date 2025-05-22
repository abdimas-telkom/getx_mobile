import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/teacher_dashboard_controller.dart';

class TeacherDashboardView extends GetView<TeacherDashboardController> {
  const TeacherDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            onPressed: controller.loadQuizzes,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value)
          return const Center(child: CircularProgressIndicator());
        if (controller.quizzes.isEmpty) {
          return Center(
            child: ElevatedButton.icon(
              onPressed: controller.createNewQuiz,
              icon: const Icon(Icons.add),
              label: const Text('Create Quiz'),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.loadQuizzes,
          child: ListView.builder(
            itemCount: controller.quizzes.length,
            itemBuilder: (context, i) {
              final quiz = controller.quizzes[i];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    quiz['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Code: ${quiz['code'] ?? 'N/A'}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => controller.viewQuizDetails(quiz['id']),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.createNewQuiz,
        child: const Icon(Icons.add),
      ),
    );
  }
}
