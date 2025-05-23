import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/question_card.dart';

import '../controllers/question_list_controller.dart';

class QuestionListView extends GetView<QuestionListController> {
  const QuestionListView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header with title and question count
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Questions', style: Theme.of(context).textTheme.titleLarge),
              Obx(
                () => Text(
                  '${c.questions.length} questions',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        const SizedBox(height: 8),
        // Question list or placeholder
        Expanded(
          child: Obx(() {
            if (c.questions.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'No questions yet. Tap the + button to add one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: c.questions.length,
              itemBuilder: (_, index) {
                final q = c.questions[index];
                return QuestionCard(q, index, c.quizId.value);
              },
            );
          }),
        ),
      ],
    );
  }
}
