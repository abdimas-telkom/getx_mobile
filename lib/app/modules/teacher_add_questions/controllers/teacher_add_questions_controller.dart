// controllers/teacher_add_questions_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

// An enum to make question type management safer and cleaner
enum QuestionType {
  multipleChoiceSingle,
  multipleChoiceMultiple,
  trueFalse,
  weightedOptions,
  matching,
}

extension QuestionTypeExtension on QuestionType {
  String get value {
    switch (this) {
      case QuestionType.multipleChoiceSingle:
        return 'multiple_choice_single';
      case QuestionType.multipleChoiceMultiple:
        return 'multiple_choice_multiple';
      case QuestionType.trueFalse:
        return 'true_false';
      case QuestionType.weightedOptions:
        return 'weighted_options';
      case QuestionType.matching:
        return 'matching';
    }
  }
}

class TeacherAddQuestionsController extends GetxController {
  final int quizId;
  final String quizTitle;
  final String quizCode;

  TeacherAddQuestionsController({
    required this.quizId,
    required this.quizTitle,
    required this.quizCode,
  });

  // --- STATE MANAGEMENT ---
  final isLoading = false.obs;
  final questionCount = 0.obs; // Renamed from 'count' for clarity

  // Common state for all question types
  final questionText = ''.obs;
  final points = 10.obs;
  final selectedQuestionType = QuestionType.multipleChoiceSingle.obs;

  // State for Multiple Choice (Single and Multiple)
  final mcAnswers = <Map<String, dynamic>>[].obs;

  // State for True/False
  final tfCorrectAnswer = true.obs;

  // State for Weighted Options
  final weightedAnswers = <Map<String, dynamic>>[].obs;

  // State for Matching
  final matchingPairs = <Map<String, dynamic>>[].obs;
  final distractorAnswers = <Map<String, dynamic>>[].obs;


  @override
  void onInit() {
    super.onInit();
    resetForm(); // Initialize the form for the default question type
  }

  /// Resets the form fields based on the currently selected question type.
  void resetForm() {
    questionText.value = '';
    points.value = 10;

    // Clear and initialize state for the default type
    mcAnswers.assignAll([
      {'answer_text': '', 'is_correct': true},
      {'answer_text': '', 'is_correct': false},
    ]);
    tfCorrectAnswer.value = true;
    weightedAnswers.assignAll([
       {'answer_text': '', 'points': 10},
       {'answer_text': '', 'points': 5},
    ]);
    matchingPairs.assignAll([
      {'prompt': '', 'correct_answer': ''},
      {'prompt': '', 'correct_answer': ''},
    ]);
    distractorAnswers.clear();
  }

  /// Called when the user changes the question type from the UI dropdown.
  void onQuestionTypeChanged(QuestionType newType) {
    selectedQuestionType.value = newType;
    // You can add logic here to preserve data when switching types if needed
  }
  
  // --- UI HELPER METHODS (You will build UI for these) ---

  // Methods for Multiple Choice
  void addMcOption() => mcAnswers.add({'answer_text': '', 'is_correct': false});
  void removeMcOption(int index) {
     if (mcAnswers.length > 2) mcAnswers.removeAt(index);
  }
  void setCorrectMcAnswer(int index) {
      for (var i = 0; i < mcAnswers.length; i++) {
        mcAnswers[i] = {...mcAnswers[i], 'is_correct': i == index};
      }
      mcAnswers.refresh();
  }
  void toggleCorrectMcAnswer(int index, bool value) {
      mcAnswers[index] = {...mcAnswers[index], 'is_correct': value};
      mcAnswers.refresh();
  }

  // Methods for Matching Type
  void addMatchingPair() => matchingPairs.add({'prompt': '', 'correct_answer': ''});
  void removeMatchingPair(int index) => matchingPairs.removeAt(index);
  void addDistractor() => distractorAnswers.add({'answer_text': ''});
  void removeDistractor(int index) => distractorAnswers.removeAt(index);

  /// Builds the correct request body and saves the question.
  Future<void> saveQuestion() async {
  // --- CLIENT-SIDE VALIDATION ---
  if (questionText.value.trim().isEmpty) {
    Get.snackbar('Validation Error', 'Question text cannot be empty.');
    return;
  }

  // Add specific validation for the current question type
  switch (selectedQuestionType.value) {
    case QuestionType.matching:
      // Check if any prompt or answer field is empty
      if (matchingPairs.any((p) =>
          p['prompt'].toString().trim().isEmpty ||
          p['correct_answer'].toString().trim().isEmpty)) {
        Get.snackbar('Validation Error', 'All prompts and answers for matching pairs must be filled.');
        return;
      }
      // Check for unique prompts
      final prompts = matchingPairs.map((p) => p['prompt'].toString().trim()).toList();
      if (prompts.toSet().length != prompts.length) {
        Get.snackbar('Validation Error', 'All prompts in a matching question must be unique.');
        return;
      }
      // Check for unique answers
      final answers = matchingPairs.map((p) => p['correct_answer'].toString().trim()).toList();
      if (answers.toSet().length != answers.length) {
        Get.snackbar('Validation Error', 'All answers in a matching question must be unique.');
        return;
      }
      break;
    case QuestionType.multipleChoiceSingle:
    case QuestionType.multipleChoiceMultiple:
       if (mcAnswers.any((a) => a['answer_text'].toString().trim().isEmpty)) {
         Get.snackbar('Validation Error', 'All multiple choice options must be filled.');
         return;
       }
      break;
    case QuestionType.weightedOptions:
       if (weightedAnswers.any((a) => a['answer_text'].toString().trim().isEmpty)) {
         Get.snackbar('Validation Error', 'All weighted options must be filled.');
         return;
       }
      break;
    case QuestionType.trueFalse:
      // No specific validation needed for options
      break;
  }

  isLoading.value = true;
  
  // --- PAYLOAD CONSTRUCTION ---
  Map<String, dynamic> questionData = {
    'question_text': questionText.value,
    'points': points.value,
    'question_type': selectedQuestionType.value.value,
  };

  switch (selectedQuestionType.value) {
    case QuestionType.multipleChoiceSingle:
    case QuestionType.multipleChoiceMultiple:
      questionData['answers'] = mcAnswers.toList();
      break;
    case QuestionType.trueFalse:
      questionData['correct_answer'] = tfCorrectAnswer.value;
      break;
    case QuestionType.weightedOptions:
      questionData['answers'] = weightedAnswers.toList();
      break;
    case QuestionType.matching:
      questionData['matching_pairs'] = matchingPairs.toList();
      questionData['distractor_answers'] = distractorAnswers
          .map((d) => d['answer_text'].toString().trim())
          .where((t) => t.isNotEmpty) // Only include non-empty distractors
          .toList();
      break;
  }

  try {
    await TeacherQuizService.addQuestion(quizId, questionData);
    
    questionCount.value++;
    Get.snackbar(
      'Success',
      'Question #${questionCount.value} has been added.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    resetForm();

  } catch (e) {
    Get.snackbar(
      'API Error',
      'Failed to save question: ${e.toString()}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}

  // Your confirmCancel and finishQuiz logic is well-designed and doesn't need changes.
  // Just ensure you use `questionCount` instead of `count`.
  Future<void> finishQuiz() async {
    if (questionCount.value == 0) {
      Get.snackbar('No Questions', 'Please add at least one question.');
      return;
    }
    Get.back(result: true); // Signal success to the previous screen
  }
  // A computed property to check if there are any unsaved changes
  bool get hasUnsavedChanges => questionText.value.trim().isNotEmpty;

  // The dialog logic for confirming cancellation
  Future<bool> confirmCancel() async {
    // Only show the dialog if there are added questions or unsaved changes
    if (questionCount.value > 0 || hasUnsavedChanges) {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Are you sure?'),
          content: Text(
            questionCount.value > 0
                ? 'You have added ${questionCount.value} questions. If you go back, the quiz will be saved with these questions.'
                : 'You have unsaved changes for the current question. If you go back, the quiz will be deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('CONTINUE EDITING'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('CONFIRM & GO BACK'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    // If there's nothing to lose, just allow popping the screen
    return true;
  }

  void addWeightedOption() => weightedAnswers.add({'answer_text': '', 'points': 0});
  void removeWeightedOption(int index) {
    if (weightedAnswers.length > 2) weightedAnswers.removeAt(index);
  }
}