import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/quiz_card.dart';
import '../controllers/teacher_dashboard_controller.dart';

class TeacherDashboardView extends GetView<TeacherDashboardController> {
  const TeacherDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadQuizzes,
          color: primaryColor,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: School Info
                      Row(
                        children: [
                          Image.asset('assets/images/logo.png', height: 40),
                          const SizedBox(width: 12),
                          Text(
                            'SDN 227 Margahayu Utara',
                            style: textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Header: Greeting and Logout
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(
                            () => Text(
                              'Hallo, ${controller.teacherName.value}!',
                              style: textTheme.displaySmall,
                            ),
                          ),
                          IconButton(
                            onPressed: controller.logout,
                            icon: const Icon(
                              Icons.exit_to_app_rounded,
                              size: 30,
                            ),
                            color: textMutedColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Main Content: Loading, Empty, or List
              Obx(() {
                if (controller.isLoading.value && controller.quizzes.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (controller.quizzes.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Belum ada ujian yang dibuat'),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: controller.createNewQuiz,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Buat Ujian'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                // Display list of quizzes
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final quiz = controller.quizzes[index];
                      return QuizCard(
                        quiz: quiz,
                        onTap: () => controller.viewQuizDetails(quiz['id']),
                      );
                    }, childCount: controller.quizzes.length),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.createNewQuiz,
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
