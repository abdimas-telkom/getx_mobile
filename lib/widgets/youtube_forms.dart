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
  final textController = controller.mcAnswerTextControllers[index];

  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Row(
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
            controller: textController,
            decoration: const InputDecoration(hintText: 'Teks Jawaban'),
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
        final textController = controller.weightedAnswerTextControllers[index];
        final pointsController =
            controller.weightedAnswerPointsControllers[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: textController,
                  decoration: const InputDecoration(hintText: 'Teks Jawaban'),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 70,
                child: TextFormField(
                  controller: pointsController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: 'Poin'),
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
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.matchingPromptControllers[index],
                    decoration: InputDecoration(
                      hintText: 'Pertanyaan ${index + 1}',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: controller.matchingAnswerControllers[index],
                    decoration: const InputDecoration(hintText: 'Jawaban'),
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
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.distractorTextControllers[index],
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
