import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/attempts_list.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/attempts_stats.dart';

import '../controllers/teacher_quiz_details_controller.dart';

class QuizAttemptListView extends GetView<TeacherQuizDetailsController> {
  const QuizAttemptListView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quiz Attempts',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: c.loadAttempts,
                tooltip: 'Refresh Attempts',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Stats
          if (c.attempts.isNotEmpty) AttemptsStats(c.attempts),
          if (c.attempts.isNotEmpty) const SizedBox(height: 16),

          // Content
          if (c.isLoadingAttempts.value)
            const Center(child: CircularProgressIndicator())
          else if (c.attempts.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'No attempts yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            AttemptsList(c.attempts),
        ],
      );
    });
  }
}
