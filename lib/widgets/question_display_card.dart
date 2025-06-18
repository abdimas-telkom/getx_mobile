import 'package:flutter/material.dart';
import 'package:ujian_sd_babakan_ciparay/app/modules/teacher_quiz_details/controllers/question_list_controller.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

Widget QuestionDisplayCard(
  Map<String, dynamic> question,
  int index,
  QuestionListController controller,
) {
  final questionText = question['question_text'] ?? 'No text';
  final answers = List<Map<String, dynamic>>.from(question['answers'] ?? []);

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                  onPressed: () => controller.editQuestion(
                    controller.quizId.value,
                    question,
                  ),
                  icon: const Icon(Icons.edit_outlined, color: textMutedColor),
                ),
                IconButton(
                  onPressed: () => controller.deleteQuestion(
                    controller.quizId.value,
                    question,
                  ),
                  icon: const Icon(Icons.delete_outline, color: redColor),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (answers.isNotEmpty)
          ...answers.map((answer) {
            final bool isCorrect = answer['is_correct'] ?? false;
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
                      answer['answer_text'],
                      style: cardSubtitle.copyWith(
                        color: isCorrect ? blackColor : textMutedColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    ),
  );
}
