import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/contracts/i_question_form_controller.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

Widget _buildMcOptionRow({
  required IQuestionFormController controller,
  required int index,
  required bool isSingleChoice,
}) {
  final answer = controller.mcAnswers[index];
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Row(
      key: ValueKey(answer),
      children: [
        isSingleChoice
            ? Radio<int>(
                value: index,
                groupValue: controller.mcAnswers.indexWhere(
                  (a) => a.isCorrect == true,
                ),
                onChanged: (i) => controller.setCorrectMcAnswer(i!),
              )
            : Checkbox(
                value: answer.isCorrect,
                onChanged: (val) =>
                    controller.toggleCorrectMcAnswer(index, val!),
              ),
        Expanded(
          child: TextFormField(
            initialValue: answer.answerText,
            onChanged: (val) => controller.mcAnswers[index].answerText = val,
            decoration: InputDecoration(hintText: 'Teks Jawaban'),
          ),
        ),
        if (controller.mcAnswers.length > 2)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: textMutedColor),
            onPressed: () => controller.removeMcOption(index),
          ),
      ],
    ),
  );
}

Widget buildMultipleChoiceForm({
  required IQuestionFormController controller,
  required bool isSingleChoice,
}) {
  return Obx(
    () => Column(
      children: List.generate(
        controller.mcAnswers.length,
        (index) => _buildMcOptionRow(
          controller: controller,
          index: index,
          isSingleChoice: isSingleChoice,
        ),
      ),
    ),
  );
}

Widget buildTrueFalseForm({required IQuestionFormController controller}) {
  return Obx(
    () => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Salah', style: cardSubtitle),
        const SizedBox(width: 8),
        Switch(
          value: controller.tfCorrectAnswer.value,
          onChanged: (val) => controller.tfCorrectAnswer.value = val,
        ),
        const SizedBox(width: 8),
        const Text('Benar', style: cardSubtitle),
      ],
    ),
  );
}

Widget buildWeightedOptionsForm({required IQuestionFormController controller}) {
  return Obx(
    () => Column(
      children: List.generate(controller.weightedAnswers.length, (index) {
        final answer = controller.weightedAnswers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: answer.answerText,
                  onChanged: (val) =>
                      controller.weightedAnswers[index].answerText = val,
                  decoration: InputDecoration(hintText: 'Teks Jawaban'),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 70,
                child: TextFormField(
                  initialValue: answer.points.toString(),
                  textAlign: TextAlign.center,
                  onChanged: (val) => controller.weightedAnswers[index].points =
                      (int.tryParse(val) ?? 0) as double?,
                  decoration: InputDecoration(hintText: 'Poin'),
                  keyboardType: TextInputType.number,
                ),
              ),
              if (controller.weightedAnswers.length > 2)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: textMutedColor),
                  onPressed: () => controller.removeWeightedOption(index),
                ),
            ],
          ),
        );
      }),
    ),
  );
}

Widget buildMatchingForm({required IQuestionFormController controller}) {
  return Obx(
    () => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Opsi Jawaban Benar', style: formLabel),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: primaryColor),
              onPressed: controller.addMatchingPair,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...List.generate(controller.matchingPairs.length, (index) {
          final pair = controller.matchingPairs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: pair.prompt,
                    onChanged: (val) =>
                        controller.matchingPairs[index].prompt = val,
                    decoration: InputDecoration(
                      hintText: 'Pertanyaan ${index + 1}',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: pair.correctAnswer,
                    onChanged: (val) =>
                        controller.matchingPairs[index].correctAnswer = val,
                    decoration: InputDecoration(hintText: 'Jawaban'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: textMutedColor),
                  onPressed: () => controller.removeMatchingPair(index),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Jawaban Salah (Opsional)', style: formLabel),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: primaryColor),
              onPressed: controller.addDistractor,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...List.generate(controller.distractorAnswers.length, (index) {
          final distractor = controller.distractorAnswers[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: distractor.answerText,
                    onChanged: (val) =>
                        controller.distractorAnswers[index].answerText = val,
                    decoration: InputDecoration(
                      hintText: 'Jawaban Salah ${index + 1}',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: textMutedColor),
                  onPressed: () => controller.removeDistractor(index),
                ),
              ],
            ),
          );
        }),
      ],
    ),
  );
}
