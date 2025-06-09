import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Assuming your controller is in this path
import '../app/modules/teacher_quiz_details/controllers/question_list_controller.dart';

// Main Widget Function
Widget QuestionCard(Map<String, dynamic> question, int index, int quizId) {
  // Using Get.find() assumes the controller is already initialized.
  // It's safer if this is passed as a parameter, but we'll stick to your structure.
  final QuestionListController controller = Get.find();

  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    elevation: 2,
    clipBehavior: Clip.antiAlias, // Ensures the inkwell ripple is contained
    child: InkWell(
      onTap: () => controller.editQuestion(quizId, question), // Make the whole card tappable
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Question Header ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Q${index + 1}: ${question['question_text']}",
                    style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                // Using a PopupMenuButton for actions is cleaner than multiple IconButtons
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      controller.editQuestion(quizId, question);
                    } else if (value == 'delete') {
                      controller.deleteQuestion(quizId, question);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: ListTile(leading: Icon(Icons.edit), title: Text('Edit')),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Delete')),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            if (question['points'] != null && question['points'] != 1) ...[
              const SizedBox(height: 4),
              Text(
                "Points: ${question['points']}",
                style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ],
            const Divider(height: 24),

            // --- Dynamic Answer Area ---
            _buildAnswerArea(question),
          ],
        ),
      ),
    ),
  );
}

/// This is the "switcher" widget. It decides which UI to build for the answers.
Widget _buildAnswerArea(Map<String, dynamic> question) {
  final type = question['question_type'];

  switch (type) {
    case 'multiple_choice_single':
    case 'multiple_choice_multiple':
    case 'true_false':
      // Use a null-coalescing operator `?? []` to default to an empty list if null
      final answers = question['answers'] as List<dynamic>? ?? [];
      return _buildMultipleChoiceAnswerList(answers);

    case 'weighted_options':
      final answers = question['answers'] as List<dynamic>? ?? [];
      return _buildWeightedAnswerList(answers);

    case 'matching':
      // Apply the same safety check here. This fixes your crash.
      final pairs = question['matching_pairs'] as List<dynamic>? ?? [];
      final distractors = question['distractor_answers'] as List<dynamic>? ?? [];
      return _buildMatchingAnswerArea(pairs, distractors);

    default:
      return const Text('Unknown question type', style: TextStyle(color: Colors.red));
  }
}

/// Builds the display for any question type that uses a simple list of answers.
Widget _buildMultipleChoiceAnswerList(List<dynamic> answers) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List<Widget>.from(answers.map((answer) {
      final bool isCorrect = answer['is_correct'] == true || (answer['is_correct'] == 1);
      return Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCorrect ? Colors.green : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(answer['answer_text'])),
          ],
        ),
      );
    })),
  );
}

/// Builds the specific display for weighted options, showing the weight percentage.
Widget _buildWeightedAnswerList(List<dynamic> answers) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List<Widget>.from(answers.map((answer) {
      final weight = (answer['weight'] as num).toDouble();
      return Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Row(
          children: [
            // Display the weight as a percentage in a chip
            Chip(
              label: Text('${(weight * 100).toStringAsFixed(0)}%'),
              backgroundColor: Colors.blue.shade50,
              labelStyle: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(answer['answer_text'])),
          ],
        ),
      );
    })),
  );
}

/// Builds the display for matching questions, showing pairs and distractors.
Widget _buildMatchingAnswerArea(List<dynamic> pairs, List<dynamic> distractors) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Correct Pairs:', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      ...List<Widget>.from(pairs.map((pair) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4),
          child: Row(
            children: [
              const Icon(Icons.arrow_right_alt, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(pair['prompt']),
              const Text('  ->  ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: Text(pair['correct_answer'])),
            ],
          ),
        );
      })),
      if (distractors.isNotEmpty) ...[
        const SizedBox(height: 16),
        const Text('Distractors:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        ...List<Widget>.from(distractors.map((distractor) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4),
            child: Row(
              children: [
                const Icon(Icons.cancel_outlined, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Text(distractor['answer_text']),
              ],
            ),
          );
        })),
      ]
    ],
  );
}