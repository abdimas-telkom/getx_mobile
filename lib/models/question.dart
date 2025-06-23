import 'package:ujian_sd_babakan_ciparay/models/answer_option.dart';
import 'package:ujian_sd_babakan_ciparay/models/matching_pair.dart';
import 'package:ujian_sd_babakan_ciparay/models/question_type.dart';

class Question {
  final int id;
  final String questionText;
  final QuestionType questionType;
  final int points;
  final List<AnswerOption> answers;
  final List<MatchingPair> matchingPairs;
  final List<AnswerOption> distractorAnswers;
  final bool? correctAnswer; // for true/false
  final List<String> prompts; // For student view of matching questions

  Question({
    required this.id,
    required this.questionText,
    required this.questionType,
    required this.points,
    this.answers = const [],
    this.matchingPairs = const [],
    this.distractorAnswers = const [],
    this.correctAnswer,
    this.prompts = const [],
  });

  /// This robust factory now handles all question JSON structures.
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionText: json['question_text'],
      questionType: QuestionTypeExtension.fromString(json['question_type']),
      points: json['points'],

      // Handles answers for multiple_choice, weighted, and true/false
      answers:
          (json['answers'] as List<dynamic>?)
              ?.map((e) => AnswerOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],

      // Handles matching pairs for the TEACHER view
      matchingPairs:
          (json['matching_pairs'] as List<dynamic>?)
              ?.map((e) => MatchingPair.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],

      // Handles matching distractors for the TEACHER view
      // Also handles answer_options for the STUDENT view of matching questions
      distractorAnswers:
          (json['distractor_answers'] as List<dynamic>?)
              ?.map((e) => AnswerOption(answerText: e.toString()))
              .toList() ??
          (json['answer_options'] as List<dynamic>?)
              ?.map((e) => AnswerOption(answerText: e.toString()))
              .toList() ??
          [],

      correctAnswer: json['correct_answer'],

      // Handles prompts for the STUDENT view of matching questions
      prompts:
          (json['prompts'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
