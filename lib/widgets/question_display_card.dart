import 'package:flutter/material.dart';
import 'package:ujian_sd_babakan_ciparay/app/modules/teacher_quiz_details/controllers/question_list_controller.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

Widget QuestionDisplayCard(
  Map<String, dynamic> question,
  int index,
  QuestionListController controller,
) {
  final questionText = question['question_text'] ?? 'No question text';
  final type = question['question_type'] as String? ?? '';

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Q${index + 1}: $questionText',
            style: cardTitle.copyWith(fontSize: 18),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () =>
                  controller.editQuestion(controller.quizId.value, question),
              icon: const Icon(Icons.edit_outlined, color: textMutedColor),
            ),
            IconButton(
              onPressed: () =>
                  controller.deleteQuestion(controller.quizId.value, question),
              icon: const Icon(Icons.delete_outline, color: redColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBody() {
    switch (type) {
      case 'multiple_choice_single':
      case 'multiple_choice_multiple':
        final answers = List<Map<String, dynamic>>.from(
          question['answers'] ?? [],
        );
        if (answers.isEmpty) return const SizedBox.shrink();
        return Column(
          children: answers.map((answer) {
            final isCorrect = answer['is_correct'] as bool? ?? false;
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: [
                  Icon(
                    isCorrect
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: isCorrect ? primaryColor : textMutedColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      answer['answer_text'] ?? '',
                      style: cardSubtitle.copyWith(
                        color: isCorrect ? blackColor : textMutedColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );

      case 'true_false':
        final correct = question['correct_answer'] as bool? ?? true;
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Icon(
                correct ? Icons.check : Icons.close,
                color: correct ? greenColor : redColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                correct ? 'True' : 'False',
                style: cardSubtitle.copyWith(
                  color: correct ? blackColor : textMutedColor,
                ),
              ),
            ],
          ),
        );

      case 'weighted_options':
        final options = List<Map<String, dynamic>>.from(
          question['answers'] ?? [],
        );
        if (options.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options.map((opt) {
            final weight = (opt['weight'] as num).toDouble();
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: [
                  Chip(
                    side: BorderSide(color: secondaryColor, width: 1),
                    label: Text('${(weight * 100).toStringAsFixed(0)}%'),
                    backgroundColor: secondaryColor.withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(opt['answer_text'])),
                ],
              ),
            );
          }).toList(),
        );

      case 'matching':
        final pairs = List<Map<String, dynamic>>.from(
          question['matching_pairs'] ?? [],
        );
        if (pairs.isEmpty) return const SizedBox.shrink();
        return Column(
          children: pairs.map((pair) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Text(pair['prompt'] ?? '', style: cardSubtitle),
                  const Text('  ->  ', style: cardSubtitle),
                  Expanded(
                    child: Text(
                      pair['correct_answer'] ?? '',
                      style: cardSubtitle.copyWith(color: primaryColor),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );

      default:
        return const Text('Unknown question type');
    }
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [buildHeader(), const SizedBox(height: 8), buildBody()],
    ),
  );
}
