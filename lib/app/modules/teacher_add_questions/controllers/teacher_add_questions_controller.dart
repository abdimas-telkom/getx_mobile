import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
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

  final isLoading = false.obs;
  final questionCount = 0.obs;

  final questionTextController = TextEditingController();
  final pointsController = TextEditingController(text: '10');

  @override
  final selectedQuestionType = QuestionType.multipleChoiceSingle.obs;

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
  final List<TextEditingController> mcAnswerTextControllers = [];
  @override
  final List<TextEditingController> weightedAnswerTextControllers = [];
  @override
  final List<TextEditingController> weightedAnswerPointsControllers = [];
  @override
  final List<TextEditingController> matchingPromptControllers = [];
  @override
  final List<TextEditingController> matchingAnswerControllers = [];
  @override
  final List<TextEditingController> distractorTextControllers = [];

  @override
  void onInit() {
    super.onInit();
    resetForm();
  }

  @override
  void onClose() {
    questionTextController.dispose();
    pointsController.dispose();
    _clearAllControllers();
    super.onClose();
  }

  void _clearAllControllers() {
    for (var c in mcAnswerTextControllers) {
      c.dispose();
    }
    mcAnswerTextControllers.clear();

    for (var c in weightedAnswerTextControllers) {
      c.dispose();
    }
    weightedAnswerTextControllers.clear();

    for (var c in weightedAnswerPointsControllers) {
      c.dispose();
    }
    weightedAnswerPointsControllers.clear();

    for (var c in matchingPromptControllers) {
      c.dispose();
    }
    matchingPromptControllers.clear();

    for (var c in matchingAnswerControllers) {
      c.dispose();
    }
    matchingAnswerControllers.clear();

    for (var c in distractorTextControllers) {
      c.dispose();
    }
    distractorTextControllers.clear();
  }

  void resetForm() {
    questionTextController.clear();
    pointsController.text = '10';
    selectedQuestionType.value = QuestionType.multipleChoiceSingle;

    _clearAllControllers();
    mcAnswers.assignAll([
      AnswerOption(answerText: '', isCorrect: true),
      AnswerOption(answerText: '', isCorrect: false),
    ]);
    for (var answer in mcAnswers) {
      mcAnswerTextControllers.add(
        TextEditingController(text: answer.answerText),
      );
    }

    tfCorrectAnswer.value = true;

    weightedAnswers.assignAll([
      AnswerOption(answerText: '', points: 10),
      AnswerOption(answerText: '', points: 5),
    ]);
    for (var answer in weightedAnswers) {
      weightedAnswerTextControllers.add(
        TextEditingController(text: answer.answerText),
      );
      weightedAnswerPointsControllers.add(
        TextEditingController(text: answer.points?.toStringAsFixed(0) ?? '0'),
      );
    }

    matchingPairs.assignAll([
      MatchingPair(prompt: '', correctAnswer: ''),
      MatchingPair(prompt: '', correctAnswer: ''),
    ]);
    for (var pair in matchingPairs) {
      matchingPromptControllers.add(TextEditingController(text: pair.prompt));
      matchingAnswerControllers.add(
        TextEditingController(text: pair.correctAnswer),
      );
    }

    distractorAnswers.clear();
  }

  void onQuestionTypeChanged(QuestionType newType) {
    selectedQuestionType.value = newType;
  }

  @override
  void addMcOption() {
    mcAnswers.add(AnswerOption(answerText: '', isCorrect: false));
    mcAnswerTextControllers.add(TextEditingController());
  }

  @override
  void removeMcOption(int index) {
    if (mcAnswers.length > 2) {
      mcAnswers.removeAt(index);
      mcAnswerTextControllers[index].dispose();
      mcAnswerTextControllers.removeAt(index);
    }
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
  void addWeightedOption() {
    weightedAnswers.add(AnswerOption(answerText: '', points: 0));
    weightedAnswerTextControllers.add(TextEditingController());
    weightedAnswerPointsControllers.add(TextEditingController(text: '0'));
  }

  @override
  void removeWeightedOption(int index) {
    if (weightedAnswers.length > 2) {
      weightedAnswers.removeAt(index);
      weightedAnswerTextControllers[index].dispose();
      weightedAnswerTextControllers.removeAt(index);
      weightedAnswerPointsControllers[index].dispose();
      weightedAnswerPointsControllers.removeAt(index);
    }
  }

  @override
  void addMatchingPair() {
    matchingPairs.add(MatchingPair(prompt: '', correctAnswer: ''));
    matchingPromptControllers.add(TextEditingController());
    matchingAnswerControllers.add(TextEditingController());
  }

  @override
  void removeMatchingPair(int index) {
    if (matchingPairs.length > 2) {
      matchingPairs.removeAt(index);
      matchingPromptControllers[index].dispose();
      matchingPromptControllers.removeAt(index);
      matchingAnswerControllers[index].dispose();
      matchingAnswerControllers.removeAt(index);
    }
  }

  @override
  void addDistractor() {
    distractorAnswers.add(AnswerOption(answerText: ''));
    distractorTextControllers.add(TextEditingController());
  }

  @override
  void removeDistractor(int index) {
    distractorAnswers.removeAt(index);
    distractorTextControllers[index].dispose();
    distractorTextControllers.removeAt(index);
  }

  Future<void> saveQuestion() async {
    final questionText = questionTextController.text.trim();
    if (questionText.isEmpty) {
      Get.snackbar('Kesalahan Validasi', 'Teks pertanyaan tidak boleh kosong.');
      return;
    }

    final points = int.tryParse(pointsController.text) ?? 10;

    isLoading.value = true;

    Map<String, dynamic> payload = {
      'question_text': questionText,
      'points': points,
      'question_type': selectedQuestionType.value.value,
    };

    switch (selectedQuestionType.value) {
      case QuestionType.multipleChoiceSingle:
      case QuestionType.multipleChoiceMultiple:
        List<Map<String, dynamic>> answersPayload = [];
        for (int i = 0; i < mcAnswers.length; i++) {
          final text = mcAnswerTextControllers[i].text.trim();
          if (text.isEmpty) {
            Get.snackbar(
              'Kesalahan Validasi',
              'Semua pilihan ganda harus diisi.',
            );
            isLoading.value = false;
            return;
          }
          answersPayload.add(
            AnswerOption(
              answerText: text,
              isCorrect: mcAnswers[i].isCorrect,
            ).toJson(),
          );
        }
        payload['answers'] = answersPayload;
        break;
      case QuestionType.trueFalse:
        payload['correct_answer'] = tfCorrectAnswer.value;
        break;
      case QuestionType.weightedOptions:
        List<Map<String, dynamic>> answersPayload = [];
        for (int i = 0; i < weightedAnswers.length; i++) {
          final text = weightedAnswerTextControllers[i].text.trim();
          if (text.isEmpty) {
            Get.snackbar(
              'Kesalahan Validasi',
              'Semua pilihan berbobot harus diisi.',
            );
            isLoading.value = false;
            return;
          }
          answersPayload.add(
            AnswerOption(
              answerText: text,
              points:
                  double.tryParse(weightedAnswerPointsControllers[i].text) ??
                  0.0,
            ).toJson(),
          );
        }
        payload['answers'] = answersPayload;
        break;
      case QuestionType.matching:
        List<Map<String, dynamic>> pairsPayload = [];
        for (int i = 0; i < matchingPairs.length; i++) {
          final prompt = matchingPromptControllers[i].text.trim();
          final answer = matchingAnswerControllers[i].text.trim();
          if (prompt.isEmpty || answer.isEmpty) {
            Get.snackbar(
              'Kesalahan Validasi',
              'Semua soal dan jawaban untuk tipe menjodohkan harus diisi.',
            );
            isLoading.value = false;
            return;
          }
          pairsPayload.add(
            MatchingPair(prompt: prompt, correctAnswer: answer).toJson(),
          );
        }
        payload['matching_pairs'] = pairsPayload;
        payload['distractor_answers'] = distractorTextControllers
            .map((c) => c.text.trim())
            .where((t) => t.isNotEmpty)
            .toList();
        break;
    }

    try {
      await TeacherQuizService.addQuestion(quizId, payload);
      questionCount.value++;
      Get.snackbar(
        'Sukses',
        'Pertanyaan #${questionCount.value} telah ditambahkan.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      resetForm();
    } catch (e) {
      Get.snackbar(
        'Kesalahan Server',
        'Gagal menyimpan pertanyaan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> finishQuiz() async {
    if (questionCount.value == 0) {
      Get.snackbar(
        'Belum Ada Pertanyaan',
        'Harap tambahkan setidaknya satu pertanyaan.',
      );
      return;
    }
    if (Get.arguments['isNewQuiz'] == true) {
      Get.toNamed(Routes.TEACHER_QUIZ_DETAILS, arguments: quizId);
    } else {
      Get.back(result: true);
    }
  }

  bool get hasUnsavedChanges => questionTextController.text.trim().isNotEmpty;

  Future<bool> confirmCancel() async {
    if (questionCount.value > 0 || hasUnsavedChanges) {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Apakah Anda Yakin?'),
          content: Text(
            questionCount.value > 0
                ? 'Anda telah menambahkan ${questionCount.value} pertanyaan. Jika Anda kembali, kuis akan disimpan dengan pertanyaan-pertanyaan ini.'
                : 'Anda memiliki perubahan yang belum disimpan. Jika Anda kembali, perubahan akan hilang.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('LANJUTKAN MENGEDIT'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('KONFIRMASI & KEMBALI'),
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
