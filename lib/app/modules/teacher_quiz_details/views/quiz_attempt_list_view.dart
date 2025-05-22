import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/teacher_quiz_details_controller.dart';

class QuizAttemptListView extends GetView<TeacherQuizDetailsController> {
  const QuizAttemptListView({super.key});
  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Obx(() {
      if (c.isLoadingAttempts.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (c.attempts.isEmpty) {
        return const Center(child: Text('No attempts'));
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: c.attempts.length,
        itemBuilder: (_, i) {
          final a = c.attempts[i];
          return ListTile(
            title: Text(a.studentName),
            subtitle: Text('Score: ${a.score}%'),
          );
        },
      );
    });
  }
}
