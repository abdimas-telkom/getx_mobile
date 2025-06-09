import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/teacher_quiz_edit_controller.dart';

class TeacherQuizEditView extends GetView<TeacherQuizEditController> {
  const TeacherQuizEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isNew ? 'Add New Question' : 'Edit Question'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Common Question Details ---
            _buildCommonDetailsCard(),
            const SizedBox(height: 24),

            // --- Dynamic Form for Answers/Options ---
            _buildFormBody(),
            const SizedBox(height: 24),
            
            // --- Save Button ---
            Obx(() => ElevatedButton.icon(
                  onPressed: controller.isSubmitting.value ? null : controller.save,
                  icon: controller.isSubmitting.value
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(controller.isNew ? 'CREATE QUESTION' : 'UPDATE QUESTION'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPointsInput({required dynamic controller}) {
  return Obx(
    () {
      // Determine if a warning should be shown
      final bool showWarning = controller.points.value > 100;

      return TextFormField(
        initialValue: controller.points.value.toString(),
        onChanged: (val) => controller.points.value = int.tryParse(val) ?? 0,
        decoration: InputDecoration(
          labelText: 'Poin Maksimal untuk Soal ini', // "Max Points for this Question"
          border: const OutlineInputBorder(),
          // Persistent helper text to guide the user
          helperText: 'Ubah jika soal ini punya bobot lebih tinggi dari yang lain.', // "Change if this question has a different weight"
          helperMaxLines: 2,
          // Conditional error/warning text
          errorText: showWarning ? 'Nilai di atas 100 tidak disarankan.' : null, // "Values above 100 are not recommended."
          errorStyle: const TextStyle(color: Colors.orange), // Use orange for a warning, not a hard error
          errorMaxLines: 2,
        ),
        keyboardType: TextInputType.number,
      );
    },
  );
}
  // A card for the details that all questions share
  Widget _buildCommonDetailsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: controller.questionText.value,
              onChanged: (val) => controller.questionText.value = val,
              decoration: const InputDecoration(
                labelText: 'Question Text',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16,),
            _buildPointsInput(controller: controller),
            const SizedBox(height: 16),
            // The dropdown should be disabled if we are editing an existing question
            // as changing the type has complex side-effects.
            // _buildQuestionTypeDropdown(),
             const SizedBox(height: 16),
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
        // Disable the dropdown if we are editing an existing question
        onChanged: controller.isNew ? (QuestionType? newValue) {
          if (newValue != null) {
            // This method should be added to the controller if you want to allow type changes
            // controller.onQuestionTypeChanged(newValue);
          }
        } : null, // Setting onChanged to null disables the dropdown
        items: QuestionType.values
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last.replaceAllMapped(
                      RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}').capitalizeFirst!),
                ))
            .toList(),
      ),
    );
  }

  // This is the core of the dynamic UI
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

  // --- FORM IMPLEMENTATIONS (NO PLACEHOLDERS) ---

  Widget _buildMultipleChoiceForm({required bool isSingleChoice}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Options', style: Get.textTheme.titleMedium),
            const Divider(),
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
        )),
      ),
    );
  }

  Widget _buildTrueFalseForm() {
    return Card(
        elevation: 2,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Correct Answer', style: Get.textTheme.titleMedium),
                    const Divider(),
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
                ))));
  }

  Widget _buildWeightedOptionsForm() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Options & Points', style: Get.textTheme.titleMedium),
                const Divider(),
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
            )),
      ),
    );
  }

  Widget _buildMatchingForm() {
    return Card(
        elevation: 2,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prompts & Correct Answers', style: Get.textTheme.titleMedium),
                    const Divider(),
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
                              onChanged: (val) => controller.matchingPairs[index]['correct_answer'] = val,
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
                    Text('Distractors (Optional wrong answers)', style: Get.textTheme.titleMedium),
                    const Divider(),
                    ...List.generate(controller.distractorAnswers.length, (index) {
                      final distractor = controller.distractorAnswers[index];
                      return Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: distractor['answer_text'],
                              onChanged: (val) => controller.distractorAnswers[index]['answer_text'] = val,
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
                ))));
  }
}