import 'package:flutter/material.dart';
import 'package:ujian_sd_babakan_ciparay/app/modules/teacher_quiz_details/controllers/question_list_controller.dart';
import 'package:ujian_sd_babakan_ciparay/models/question.dart';
import 'package:ujian_sd_babakan_ciparay/models/question_type.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

Widget QuestionDisplayCard(
  Question question,
  int index,
  QuestionListController controller,
) {
  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Q${index + 1}: ${question.questionText}',
            style: cardTitle.copyWith(fontSize: 18),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                controller.editQuestion(question);
              },
              icon: const Icon(Icons.edit_outlined, color: textMutedColor),
            ),
            IconButton(
              onPressed: () => controller.deleteQuestion(question),
              icon: const Icon(
                Icons.delete_outline,
                color: Color.fromARGB(202, 244, 67, 54),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBody() {
    switch (question.questionType) {
      case QuestionType.multipleChoiceSingle:
      case QuestionType.multipleChoiceMultiple:
        if (question.answers.isEmpty) return const SizedBox.shrink();
        return Column(
          children: question.answers.map((answer) {
            final isCorrect = answer.isCorrect ?? false;
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
                      answer.answerText,
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

      case QuestionType.trueFalse:
        final correct = question.correctAnswer ?? true;
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

      case QuestionType.weightedOptions:
        if (question.answers.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: question.answers.map((opt) {
            final weight = opt.points ?? 0.0;
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: [
                  Chip(
                    side: BorderSide(color: secondaryColor, width: 1),
                    label: Text((weight).toStringAsFixed(0)),
                    backgroundColor: secondaryColor.withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(opt.answerText)),
                ],
              ),
            );
          }).toList(),
        );

      case QuestionType.matching:
        if (question.matchingPairs.isEmpty) return const SizedBox.shrink();
        return Column(
          children: question.matchingPairs.map((pair) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Text(pair.prompt, style: cardSubtitle),
                  const Text('  ->  ', style: cardSubtitle),
                  Expanded(
                    child: Text(
                      pair.correctAnswer,
                      style: cardSubtitle.copyWith(color: primaryColor),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
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
