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
  static QuestionType fromString(String type) {
    switch (type) {
      case 'multiple_choice_single':
        return QuestionType.multipleChoiceSingle;
      case 'multiple_choice_multiple':
        return QuestionType.multipleChoiceMultiple;
      case 'true_false':
        return QuestionType.trueFalse;
      case 'weighted_options':
        return QuestionType.weightedOptions;
      case 'matching':
        return QuestionType.matching;
      default:
        throw Exception('Unknown question type: $type');
    }
  }
}
class TeacherQuizEditController extends GetxController {
  final int quizId;
  final Map<String, dynamic>? questionData;

  TeacherQuizEditController({required this.quizId, this.questionData});

  // --- COMMON STATE ---
  final isSubmitting = false.obs;
  final questionText = ''.obs;
  final points = 10.obs;
  late final Rx<QuestionType> selectedQuestionType; // Initialized in onInit

  // --- STATE FOR EACH QUESTION TYPE ---
  final mcAnswers = <Map<String, dynamic>>[].obs;
  final tfCorrectAnswer = true.obs;
  final weightedAnswers = <Map<String, dynamic>>[].obs;
  final matchingPairs = <Map<String, dynamic>>[].obs;
  final distractorAnswers = <Map<String, dynamic>>[].obs;

  bool get isNew => questionData == null;
  int? get questionId => isNew ? null : questionData!['id'];

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
  }

  /// Populates the form based on existing questionData or sets defaults for a new question.
  void _initializeForm() {
    if (isNew) {
      // --- DEFAULT STATE FOR A NEW QUESTION ---
      selectedQuestionType = QuestionType.multipleChoiceSingle.obs;
      mcAnswers.assignAll([
        {'answer_text': '', 'is_correct': true},
        {'answer_text': '', 'is_correct': false},
      ]);
      return;
    }

    // --- POPULATE STATE FROM EXISTING QUESTION DATA ---
    questionText.value = questionData!['question_text'] ?? '';
    points.value = questionData!['points'] ?? 10;
    selectedQuestionType = QuestionTypeExtension.fromString(questionData!['question_type']).obs;

    switch (selectedQuestionType.value) {
      case QuestionType.multipleChoiceSingle:
      case QuestionType.multipleChoiceMultiple:
        final answersList = List<Map<String, dynamic>>.from(questionData!['answers'] ?? []);
        mcAnswers.assignAll(answersList);
        break;

      case QuestionType.trueFalse:
        final answersList = List<Map<String, dynamic>>.from(questionData!['answers'] ?? []);
        final trueAnswer = answersList.firstWhere(
          (a) => a['answer_text'] == 'True',
          orElse: () => {'is_correct': true},
        );
        tfCorrectAnswer.value = trueAnswer['is_correct'];
        break;

      case QuestionType.weightedOptions:
        final answersList = List<Map<String, dynamic>>.from(questionData!['answers'] ?? []);
        weightedAnswers.assignAll(answersList.map((a) {
          return {
            'id': a['id'],
            'answer_text': a['answer_text'],
            'points': ((a['weight'] as double) * 100).round(),
          };
        }).toList());
        break;

      case QuestionType.matching:
        final pairsList = List<Map<String, dynamic>>.from(questionData!['matching_pairs'] ?? []);
        final distractorsList = List<Map<String, dynamic>>.from(questionData!['distractor_answers'] ?? []);
        matchingPairs.assignAll(pairsList);
        distractorAnswers.assignAll(distractorsList.map((d) => {'answer_text': d['answer_text']}).toList());
        break;
    }
  }

  // --- UI HELPER METHODS ---
  void addMcOption() => mcAnswers.add({'answer_text': '', 'is_correct': false});
  void removeMcOption(int index) { if (mcAnswers.length > 2) mcAnswers.removeAt(index); }
  
  void setCorrectMcAnswer(int index) {
    for (var i = 0; i < mcAnswers.length; i++) {
      mcAnswers[i] = {...mcAnswers[i], 'is_correct': i == index};
    }
    mcAnswers.refresh();
  }

  void toggleCorrectMcAnswer(int index, bool value) {
    if (index < mcAnswers.length) {
      mcAnswers[index] = {...mcAnswers[index], 'is_correct': value};
      mcAnswers.refresh();
    }
  }

  void addWeightedOption() => weightedAnswers.add({'answer_text': '', 'points': 0});
  void removeWeightedOption(int index) { if (weightedAnswers.length > 2) weightedAnswers.removeAt(index); }
  
  void addMatchingPair() => matchingPairs.add({'prompt': '', 'correct_answer': ''});
  void removeMatchingPair(int index) => matchingPairs.removeAt(index);
  
  void addDistractor() => distractorAnswers.add({'answer_text': ''});
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
        payload['answers'] = mcAnswers.map((a) => {
          if(a.containsKey('id')) 'id': a['id'],
          'answer_text': a['answer_text'],
          'is_correct': a['is_correct'],
        }).toList();
        break;
      case QuestionType.trueFalse:
        payload['correct_answer'] = tfCorrectAnswer.value;
        break;
      case QuestionType.weightedOptions:
        payload['answers'] = weightedAnswers.map((a) => {
          if(a.containsKey('id')) 'id': a['id'],
          'answer_text': a['answer_text'],
          'points': a['points'],
        }).toList();
        break;
      case QuestionType.matching:
        payload['matching_pairs'] = matchingPairs.map((p) => {
           if(p.containsKey('id')) 'id': p['id'],
          'prompt': p['prompt'],
          'correct_answer': p['correct_answer'],
        }).toList();
        payload['distractor_answers'] = distractorAnswers.map((d) => d['answer_text']).toList();
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
}