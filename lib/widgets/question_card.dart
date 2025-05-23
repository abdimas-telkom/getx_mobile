import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../app/modules/teacher_quiz_details/controllers/question_list_controller.dart';

Widget QuestionCard(Map<String, dynamic> question, int index, int quizId) {
  final QuestionListController controller = Get.find();
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Q${index + 1}: ${question['question_text']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => controller.editQuestion(quizId, question),
                tooltip: 'Edit Question',
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: () => controller.deleteQuestion(quizId, question),
                tooltip: 'Delete Question',
              ),
            ],
          ),
          if (question['points'] != null && question['points'] != 1) ...[
            const SizedBox(height: 4),
            Text(
              "Points: ${question['points']}",
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
          const SizedBox(height: 8),
          ...List<Widget>.from(
            (question['answers'] as List<dynamic>).map((answer) {
              final correct = answer['is_correct'] == true;
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Icon(
                      correct ? Icons.check_circle : Icons.circle_outlined,
                      color: correct ? Colors.green : null,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(answer['answer_text'])),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    ),
  );
}
