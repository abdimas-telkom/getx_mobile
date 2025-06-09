import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/teacher_add_questions_controller.dart';

class TeacherAddQuestionsView extends GetView<TeacherAddQuestionsController> {
  const TeacherAddQuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (await controller.confirmCancel()) {
          Get.back(result: controller.questionCount.value > 0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Questions (${controller.quizTitle})'),
          actions: [
            TextButton(
              onPressed: controller.finishQuiz,
              child: const Text('FINISH', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildQuizInfoCard(),
                      const SizedBox(height: 24),
                      _buildQuestionFormCard(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildQuizInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quiz Code: ${controller.quizCode}', style: Get.textTheme.titleMedium),
            const SizedBox(height: 8),
            Obx(() => Text('Questions Added: ${controller.questionCount.value}',
                style: Get.textTheme.bodyLarge)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionFormCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('New Question', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: controller.questionText.value),
              onChanged: (v) => controller.questionText.value = v,
              decoration: const InputDecoration(labelText: 'Question Text', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildQuestionTypeDropdown(),
            const SizedBox(height: 24),
            // A widget that dynamically builds the correct form based on selection
            _buildFormBody(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.saveQuestion,
              icon: const Icon(Icons.add_task),
              label: const Text('ADD THIS QUESTION'),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionTypeDropdown() {
    return Obx(
      () => DropdownButtonFormField<QuestionType>(
        value: controller.selectedQuestionType.value,
        decoration: const InputDecoration(labelText: 'Question Type', border: OutlineInputBorder()),
        items: QuestionType.values
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last.replaceAllMapped(
                      RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}').capitalizeFirst!),
                ))
            .toList(),
        onChanged: (QuestionType? newValue) {
          if (newValue != null) {
            controller.onQuestionTypeChanged(newValue);
          }
        },
      ),
    );
  }

  Widget _buildFormBody() {
    return Obx(() {
      switch (controller.selectedQuestionType.value) {
        case QuestionType.multipleChoiceSingle:
          return _buildMultipleChoiceForm(isSingleChoice: true);
        case QuestionType.multipleChoiceMultiple:
          return _buildMultipleChoiceForm(isSingleChoice: false);
        case QuestionType.trueFalse:
          return _buildTrueFalseForm();
        case QuestionType.weightedOptions:
          return _buildWeightedOptionsForm();
        case QuestionType.matching:
          return _buildMatchingForm();
      }
    });
  }

  Widget _buildMultipleChoiceForm({required bool isSingleChoice}) {
    // Fully implemented for both single and multiple choice
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Options', style: TextStyle(fontWeight: FontWeight.bold)),
            ...List.generate(controller.mcAnswers.length, (index) {
              final answer = controller.mcAnswers[index];
              return Row(
                children: [
                  isSingleChoice
                      ? Radio<int>(
                          value: index,
                          groupValue: controller.mcAnswers.indexWhere((a) => a['is_correct'] == true),
                          onChanged: (i) => controller.setCorrectMcAnswer(i!),
                        )
                      : Checkbox(
                          value: answer['is_correct'],
                          onChanged: (val) => controller.toggleCorrectMcAnswer(index, val!),
                        ),
                  Expanded(
                    child: TextFormField(
                      initialValue: answer['answer_text'],
                      onChanged: (val) => controller.mcAnswers[index]['answer_text'] = val,
                      decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                    ),
                  ),
                  if (controller.mcAnswers.length > 2)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: () => controller.removeMcOption(index),
                    )
                ],
              );
            }),
            TextButton.icon(
              onPressed: controller.addMcOption,
              icon: const Icon(Icons.add),
              label: const Text('Add Option'),
            )
          ],
        ));
  }

  Widget _buildTrueFalseForm() {
    // Fully implemented
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Correct Answer', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('False'),
                Switch(
                  value: controller.tfCorrectAnswer.value,
                  onChanged: (val) => controller.tfCorrectAnswer.value = val,
                ),
                const Text('True'),
              ],
            )
          ],
        ));
  }

  Widget _buildWeightedOptionsForm() {
    // Fully implemented
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Options & Points', style: TextStyle(fontWeight: FontWeight.bold)),
            ...List.generate(controller.weightedAnswers.length, (index) {
              final answer = controller.weightedAnswers[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: answer['answer_text'],
                      onChanged: (val) => controller.weightedAnswers[index]['answer_text'] = val,
                      decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      initialValue: answer['points'].toString(),
                      onChanged: (val) =>
                          controller.weightedAnswers[index]['points'] = int.tryParse(val) ?? 0,
                      decoration: const InputDecoration(labelText: 'Points'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  if (controller.weightedAnswers.length > 2)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: () => controller.removeWeightedOption(index),
                    )
                ],
              );
            }),
            TextButton.icon(
              onPressed: controller.addWeightedOption,
              icon: const Icon(Icons.add),
              label: const Text('Add Option'),
            )
          ],
        ));
  }

  Widget _buildMatchingForm() {
    // Fully implemented
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Prompts & Correct Answers', style: TextStyle(fontWeight: FontWeight.bold)),
            ...List.generate(controller.matchingPairs.length, (index) {
              final pair = controller.matchingPairs[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: pair['prompt'],
                      onChanged: (val) => controller.matchingPairs[index]['prompt'] = val,
                      decoration: InputDecoration(labelText: 'Prompt ${index + 1}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: pair['correct_answer'],
                      onChanged: (val) =>
                          controller.matchingPairs[index]['correct_answer'] = val,
                      decoration: InputDecoration(labelText: 'Answer ${index + 1}'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => controller.removeMatchingPair(index),
                  )
                ],
              );
            }),
            TextButton.icon(
              onPressed: controller.addMatchingPair,
              icon: const Icon(Icons.add),
              label: const Text('Add Pair'),
            ),
            const SizedBox(height: 24),
            const Text('Distractors (Optional wrong answers)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...List.generate(controller.distractorAnswers.length, (index) {
              final distractor = controller.distractorAnswers[index];
              return Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: distractor['answer_text'],
                      onChanged: (val) =>
                          controller.distractorAnswers[index]['answer_text'] = val,
                      decoration: InputDecoration(labelText: 'Distractor ${index + 1}'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => controller.removeDistractor(index),
                  )
                ],
              );
            }),
            TextButton.icon(
              onPressed: controller.addDistractor,
              icon: const Icon(Icons.add),
              label: const Text('Add Distractor'),
            )
          ],
        ));
  }
}