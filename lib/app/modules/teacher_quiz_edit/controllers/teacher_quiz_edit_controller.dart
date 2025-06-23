import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/contracts/i_question_form_controller.dart';
import 'package:ujian_sd_babakan_ciparay/models/answer_option.dart';
import 'package:ujian_sd_babakan_ciparay/models/matching_pair.dart';
import 'package:ujian_sd_babakan_ciparay/models/question.dart';
import 'package:ujian_sd_babakan_ciparay/models/question_type.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

class TeacherQuizEditController extends GetxController
    implements IQuestionFormController {
  final Question? question;
  final int quizId;

  TeacherQuizEditController({required this.quizId, this.question});

  // --- COMMON STATE ---
  final isSubmitting = false.obs;
  final questionText = ''.obs;
  final points = 10.obs;

  @override
  late final Rx<QuestionType> selectedQuestionType;

  // --- STRONGLY-TYPED STATE ---
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

  bool get isNew => question == null;
  int? get questionId => question?.id;

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
  }

  void _initializeForm() {
    if (isNew) {
      selectedQuestionType = QuestionType.multipleChoiceSingle.obs;
      mcAnswers.assignAll([
        AnswerOption(answerText: '', isCorrect: true),
        AnswerOption(answerText: '', isCorrect: false),
      ]);
      return;
    }

    final q = question!;
    questionText.value = q.questionText;
    points.value = q.points;
    selectedQuestionType = q.questionType.obs;

    switch (q.questionType) {
      case QuestionType.multipleChoiceSingle:
      case QuestionType.multipleChoiceMultiple:
        mcAnswers.assignAll(q.answers);
        break;
      case QuestionType.trueFalse:
        tfCorrectAnswer.value = q.correctAnswer ?? true;
        break;
      case QuestionType.weightedOptions:
        weightedAnswers.assignAll(q.answers);
        break;
      case QuestionType.matching:
        matchingPairs.assignAll(q.matchingPairs);
        distractorAnswers.assignAll(q.answers);
        break;
    }
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
      final currentAnswer = mcAnswers[i];
      // *** FIX: Recreate the object to preserve its ID and other data. ***
      mcAnswers[i] = AnswerOption(
        id: currentAnswer.id,
        answerText: currentAnswer.answerText,
        isCorrect: i == index,
      );
    }
  }

  @override
  void toggleCorrectMcAnswer(int index, bool value) {
    if (index < mcAnswers.length) {
      final currentAnswer = mcAnswers[index];
      // *** FIX: Recreate the object to preserve its ID and other data. ***
      mcAnswers[index] = AnswerOption(
        id: currentAnswer.id,
        answerText: currentAnswer.answerText,
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

  Future<void> save() async {
    isSubmitting.value = true;

    final Map<String, dynamic> payload = {
      'question_text': questionText.value,
      'points': points.value,
      'question_type': selectedQuestionType.value.value,
    };

    switch (selectedQuestionType.value) {
      case QuestionType.multipleChoiceSingle:
      case QuestionType.multipleChoiceMultiple:
        payload['answers'] = mcAnswers.map((a) => a.toJson()).toList();
        break;
      case QuestionType.trueFalse:
        payload['correct_answer'] = tfCorrectAnswer.value;
        break;
      case QuestionType.weightedOptions:
        payload['answers'] = weightedAnswers.map((a) => a.toJson()).toList();
        break;
      case QuestionType.matching:
        payload['matching_pairs'] = matchingPairs
            .map((p) => p.toJson())
            .toList();
        payload['distractor_answers'] = distractorAnswers
            .map((d) => d.answerText)
            .toList();
        break;
    }

    try {
      if (isNew) {
        await TeacherQuizService.addQuestion(quizId, payload);
      } else {
        await TeacherQuizService.updateQuestion(quizId, questionId!, payload);
      }
      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save question: ${e.toString()}');
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
