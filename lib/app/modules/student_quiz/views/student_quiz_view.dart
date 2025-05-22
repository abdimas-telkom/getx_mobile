import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/student_quiz_controller.dart';

class StudentQuizView extends GetView<StudentQuizController> {
  const StudentQuizView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value)
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      final q = controller.questions[controller.currentIndex.value];
      final answers = q['answers'] as List<dynamic>;
      final selected =
          controller.userAnswers[controller.currentIndex.value]['answer_id'];
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Question ${controller.currentIndex.value + 1}/${controller.questions.length}',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                q['question_text'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...answers.map(
                (a) => Card(
                  color: selected == a['id'] ? Colors.blue.shade50 : null,
                  child: ListTile(
                    leading: selected == a['id']
                        ? const Icon(Icons.check_circle)
                        : const Icon(Icons.circle_outlined),
                    title: Text(a['answer_text']),
                    onTap: () => controller.selectAnswer(a['id']),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  controller.currentIndex.value > 0
                      ? ElevatedButton(
                          onPressed: controller.previous,
                          child: const Text('Previous'),
                        )
                      : const SizedBox(width: 100),
                  ElevatedButton(
                    onPressed: controller.next,
                    child: Text(
                      controller.currentIndex.value ==
                              controller.questions.length - 1
                          ? 'Submit'
                          : 'Next',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
