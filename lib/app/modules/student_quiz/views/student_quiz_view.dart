import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/student_quiz_controller.dart';

class StudentQuizView extends GetView<StudentQuizController> {
  const StudentQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Use Obx to make the title reactive
        title: Obx(() => controller.questions.isEmpty
            ? const Text('Loading...')
            : Text(
                'Question ${controller.currentIndex.value + 1}/${controller.questions.length}')),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.questions.isEmpty) {
          return const Center(child: Text('No questions found for this quiz.'));
        }

        // Get the current question map from the controller
        final question = controller.currentQuestion;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Question Text ---
              Text(
                question['question_text'],
                style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // --- Dynamic Answer Area ---
              Expanded(
                child: _buildQuestionBody(question),
              ),

              // --- Navigation ---
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  controller.currentIndex.value > 0
                      ? OutlinedButton.icon(
                          onPressed: controller.previous,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Previous'),
                        )
                      : const SizedBox.shrink(), // Hide button on first question
                  ElevatedButton.icon(
                    onPressed: controller.next,
                    icon: controller.isSubmitting.value 
                        ? Container(
                            width: 24, height: 24, 
                            child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3,))
                        : Icon(controller.currentIndex.value == controller.questions.length - 1
                            ? Icons.check_circle
                            : Icons.arrow_forward),
                    label: Text(controller.currentIndex.value == controller.questions.length - 1
                        ? 'Submit'
                        : 'Next'),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  /// This widget acts as a router, deciding which UI to build based on question type.
  Widget _buildQuestionBody(Map<String, dynamic> question) {
    final questionType = question['question_type'];
    
    switch (questionType) {
      case 'multiple_choice_single':
        return _buildMultipleChoiceUI(question, isSingleChoice: true);
      case 'multiple_choice_multiple':
        return _buildMultipleChoiceUI(question, isSingleChoice: false);
      case 'true_false':
        // True/False is just a specific case of single-choice
        return _buildMultipleChoiceUI(question, isSingleChoice: true);
      case 'weighted_options':
        // Weighted options are also single-choice from the student's perspective
        return _buildMultipleChoiceUI(question, isSingleChoice: true);
      case 'matching':
        return _buildMatchingUI(question);
      default:
        return Center(child: Text('Unsupported question type: $questionType'));
    }
  }

  /// Builds the UI for both single and multiple choice questions.
  Widget _buildMultipleChoiceUI(Map<String, dynamic> question, {required bool isSingleChoice}) {
    final questionId = question['id'];
    final options = List<Map<String, dynamic>>.from(question['answers']);

    return Obx(() {
      final dynamic selectedAnswer = controller.userAnswers[questionId];

      return ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final optionId = option['id'];

          if (isSingleChoice) {
            return Card(
              color: selectedAnswer == optionId ? Get.theme.colorScheme.primaryContainer : null,
              child: RadioListTile<int>(
                title: Text(option['answer_text']),
                value: optionId,
                groupValue: selectedAnswer,
                onChanged: (value) {
                  if (value != null) {
                    controller.selectSingleAnswer(questionId, value);
                  }
                },
              ),
            );
          } else {
            // For multiple choice
            final List<int> selectedIds = List<int>.from(selectedAnswer ?? []);
            return Card(
              color: selectedIds.contains(optionId) ? Get.theme.colorScheme.primaryContainer : null,
              child: CheckboxListTile(
                title: Text(option['answer_text']),
                value: selectedIds.contains(optionId),
                onChanged: (value) {
                  if (value != null) {
                    controller.toggleMultiAnswer(questionId, optionId);
                  }
                },
              ),
            );
          }
        },
      );
    });
  }

  /// Builds the UI for matching questions.
  Widget _buildMatchingUI(Map<String, dynamic> question) {
    final questionId = question['id'];
    final prompts = List<String>.from(question['prompts']);
    final answerOptions = List<String>.from(question['answer_options']);

    return Obx(() {
       final List<Map<String, String>> selectedPairs = List<Map<String, String>>.from(controller.userAnswers[questionId] ?? []);
      
      return ListView.builder(
        itemCount: prompts.length,
        itemBuilder: (context, index) {
          final prompt = prompts[index];
          // Find the currently selected answer for this prompt
          final currentSelection = selectedPairs.firstWhere(
            (pair) => pair['prompt'] == prompt,
            orElse: () => {'selected_answer': ''},
          )['selected_answer'];

          return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(prompt, style: const TextStyle(fontWeight: FontWeight.bold))),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: currentSelection!.isEmpty ? null : currentSelection,
                      hint: const Text('Select an answer...'),
                      items: answerOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          controller.selectMatchingAnswer(questionId, prompt, newValue);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}