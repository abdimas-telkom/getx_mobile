import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/contracts/i_question_form_controller.dart';
import 'package:ujian_sd_babakan_ciparay/models/answer_option.dart';
import 'package:ujian_sd_babakan_ciparay/models/matching_pair.dart';
import 'package:ujian_sd_babakan_ciparay/models/question_type.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

class TeacherAddQuestionsController extends GetxController
    implements IQuestionFormController {
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
  final questionCount = 0.obs;

  // Common state
  final questionText = ''.obs;
  final points = 10.obs;

  @override
  final selectedQuestionType = QuestionType.multipleChoiceSingle.obs;

  // --- STRONGLY-TYPED STATE FOR EACH QUESTION TYPE ---
  @override
  final mcAnswers = <AnswerOption>[].obs;
  @override
  final tfCorrectAnswer = true.obs;
  @override
  final weightedAnswers = <AnswerOption>[].obs;
  @override
  final matchingPairs = <MatchingPair>[].obs;
  @override
  final distractorAnswers = <AnswerOption>[].obs;

  @override
  void onInit() {
    super.onInit();
    resetForm(); // Initialize the form for the default question type
  }

  /// Resets the form fields to their default state for adding a new question.
  void resetForm() {
    questionText.value = '';
    points.value = 10;
    selectedQuestionType.value =
        QuestionType.multipleChoiceSingle; // Reset type

    mcAnswers.assignAll([
      AnswerOption(answerText: '', isCorrect: true),
      AnswerOption(answerText: '', isCorrect: false),
    ]);
    tfCorrectAnswer.value = true;
    weightedAnswers.assignAll([
      AnswerOption(answerText: '', points: 10),
      AnswerOption(answerText: '', points: 5),
    ]);
    matchingPairs.assignAll([
      MatchingPair(prompt: '', correctAnswer: ''),
      MatchingPair(prompt: '', correctAnswer: ''),
    ]);
    distractorAnswers.clear();
  }

  /// Called when the user changes the question type from the UI dropdown.
  void onQuestionTypeChanged(QuestionType newType) {
    selectedQuestionType.value = newType;
  }

  // --- UI HELPER METHODS ---

  @override
  void addMcOption() =>
      mcAnswers.add(AnswerOption(answerText: '', isCorrect: false));
  @override
  void removeMcOption(int index) {
    if (mcAnswers.length > 2) mcAnswers.removeAt(index);
  }

  @override
  void setCorrectMcAnswer(int index) {
    for (var i = 0; i < mcAnswers.length; i++) {
      final current = mcAnswers[i];
      mcAnswers[i] = AnswerOption(
        id: current.id,
        answerText: current.answerText,
        isCorrect: i == index,
      );
    }
  }

  @override
  void toggleCorrectMcAnswer(int index, bool value) {
    if (index < mcAnswers.length) {
      final current = mcAnswers[index];
      mcAnswers[index] = AnswerOption(
        id: current.id,
        answerText: current.answerText,
        isCorrect: value,
      );
    }
  }

  @override
  void addWeightedOption() =>
      weightedAnswers.add(AnswerOption(answerText: '', points: 0));
  @override
  void removeWeightedOption(int index) {
    if (weightedAnswers.length > 2) weightedAnswers.removeAt(index);
  }

  @override
  void addMatchingPair() =>
      matchingPairs.add(MatchingPair(prompt: '', correctAnswer: ''));
  @override
  void removeMatchingPair(int index) => matchingPairs.removeAt(index);

  @override
  void addDistractor() => distractorAnswers.add(AnswerOption(answerText: ''));
  @override
  void removeDistractor(int index) => distractorAnswers.removeAt(index);

  Future<void> saveQuestion() async {
    if (questionText.value.trim().isEmpty) {
      Get.snackbar('Terjadi Kesalahan', 'Kolom pertanyaan tidak boleh kosong.');
      return;
    }

    // --- PAYLOAD CONSTRUCTION ---
    final Map<String, dynamic> payload = {
      'question_text': questionText.value,
      'points': points.value,
      'question_type': selectedQuestionType.value.value,
    };

    switch (selectedQuestionType.value) {
      case QuestionType.multipleChoiceSingle:
      case QuestionType.multipleChoiceMultiple:
        if (mcAnswers.any((a) => a.answerText.trim().isEmpty)) {
          Get.snackbar(
            'Terjadi Kesalahan',
            'Semua opsi pilihan ganda harus diisi.',
          );
          return;
        }
        payload['answers'] = mcAnswers.map((a) => a.toJson()).toList();
        break;
      case QuestionType.trueFalse:
        payload['correct_answer'] = tfCorrectAnswer.value;
        break;
      case QuestionType.weightedOptions:
        if (weightedAnswers.any((a) => a.answerText.trim().isEmpty)) {
          Get.snackbar('Terjadi Kesalahan', 'Semua opsi berbobot harus diisi.');
          return;
        }
        payload['answers'] = weightedAnswers.map((a) => a.toJson()).toList();
        break;
      case QuestionType.matching:
        if (matchingPairs.any(
          (p) => p.prompt.trim().isEmpty || p.correctAnswer.trim().isEmpty,
        )) {
          Get.snackbar(
            'Terjadi Kesalahan',
            'Semua prompt dan jawaban untuk pasangan yang cocok harus diisi.',
          );
          return;
        }
        payload['matching_pairs'] = matchingPairs
            .map((p) => p.toJson())
            .toList();
        payload['distractor_answers'] = distractorAnswers
            .map((d) => d.answerText.trim())
            .where((t) => t.isNotEmpty)
            .toList();
        break;
    }

    isLoading.value = true;
    try {
      await TeacherQuizService.addQuestion(quizId, payload);
      questionCount.value++;
      Get.snackbar(
        'Berhasil!',
        'Pertanyaan #${questionCount.value} telah ditambahkan.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      resetForm();
    } catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        'Gagal menyimpan pertanyaan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- FINISH & CANCEL LOGIC ---

  Future<void> finishQuiz() async {
    if (questionCount.value == 0) {
      Get.snackbar(
        'Tidak ada Pertanyaan',
        'Silakan tambahkan setidaknya satu pertanyaan.',
      );
      return;
    }
    Get.back(result: true);
  }

  bool get hasUnsavedChanges => questionText.value.trim().isNotEmpty;

  Future<bool> confirmCancel() async {
    if (questionCount.value > 0 || hasUnsavedChanges) {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Are you sure?'),
          content: Text(
            questionCount.value > 0
                ? 'You have added ${questionCount.value} questions. If you go back, the quiz will be saved with these questions.'
                : 'You have unsaved changes. If you go back, they will be lost.',
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
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
