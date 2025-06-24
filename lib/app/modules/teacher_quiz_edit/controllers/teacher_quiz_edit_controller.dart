import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/contracts/i_question_form_controller.dart';
import 'package:ujian_sd_babakan_ciparay/models/answer_option.dart';
import 'package:ujian_sd_babakan_ciparay/models/matching_pair.dart';
import 'package:ujian_sd_babakan_ciparay/models/question.dart';
import 'package:ujian_sd_babakan_ciparay/models/question_type.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

class TeacherQuizEditController extends GetxController
    implements IQuestionFormController {
  final Question question;
  final int quizId;

  TeacherQuizEditController({required this.quizId, required this.question});

  // --- COMMON STATE ---
  final isSubmitting = false.obs;
  late final TextEditingController questionTextController;
  late final TextEditingController pointsController;

  @override
  late final Rx<QuestionType> selectedQuestionType;

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

  // --- TEXT EDITING CONTROLLERS ---
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

  bool get isNew => false;
  int get questionId => question.id;

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
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

  void _initializeForm() {
    questionTextController = TextEditingController(text: question.questionText);
    pointsController = TextEditingController(text: question.points.toString());
    selectedQuestionType = question.questionType.obs;

    switch (question.questionType) {
      case QuestionType.multipleChoiceSingle:
      case QuestionType.multipleChoiceMultiple:
        mcAnswers.assignAll(question.answers);
        for (var answer in mcAnswers) {
          mcAnswerTextControllers.add(
            TextEditingController(text: answer.answerText),
          );
        }
        break;
      case QuestionType.trueFalse:
        tfCorrectAnswer.value = question.correctAnswer ?? true;
        break;
      case QuestionType.weightedOptions:
        weightedAnswers.assignAll(question.answers);
        for (var answer in weightedAnswers) {
          weightedAnswerTextControllers.add(
            TextEditingController(text: answer.answerText),
          );
          weightedAnswerPointsControllers.add(
            TextEditingController(
              text: answer.points?.toStringAsFixed(0) ?? '0',
            ),
          );
        }
        break;
      case QuestionType.matching:
        matchingPairs.assignAll(question.matchingPairs);
        for (var pair in matchingPairs) {
          matchingPromptControllers.add(
            TextEditingController(text: pair.prompt),
          );
          matchingAnswerControllers.add(
            TextEditingController(text: pair.correctAnswer),
          );
        }
        distractorAnswers.assignAll(question.distractorAnswers);
        for (var distractor in distractorAnswers) {
          distractorTextControllers.add(
            TextEditingController(text: distractor.answerText),
          );
        }
        break;
    }
  }

  // --- UI HELPER METHODS ---
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

  Future<void> save() async {
    isSubmitting.value = true;
    final points = int.tryParse(pointsController.text) ?? 10;

    Map<String, dynamic> payload = {
      'question_text': questionTextController.text.trim(),
      'points': points,
      'question_type': selectedQuestionType.value.value,
    };

    switch (selectedQuestionType.value) {
      case QuestionType.multipleChoiceSingle:
      case QuestionType.multipleChoiceMultiple:
        List<Map<String, dynamic>> answersPayload = [];
        for (int i = 0; i < mcAnswers.length; i++) {
          answersPayload.add(
            AnswerOption(
              id: mcAnswers[i].id,
              answerText: mcAnswerTextControllers[i].text,
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
          answersPayload.add(
            AnswerOption(
              id: weightedAnswers[i].id,
              answerText: weightedAnswerTextControllers[i].text,
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
          pairsPayload.add(
            MatchingPair(
              id: matchingPairs[i].id,
              prompt: matchingPromptControllers[i].text,
              correctAnswer: matchingAnswerControllers[i].text,
            ).toJson(),
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
      await TeacherQuizService.updateQuestion(quizId, questionId, payload);
      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Kesalahan', 'Gagal menyimpan pertanyaan: ${e.toString()}');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
