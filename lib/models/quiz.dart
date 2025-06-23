import 'package:ujian_sd_babakan_ciparay/models/question.dart';

class Quiz {
  final int id;
  final String title;
  final String? description;
  final String code;
  final bool isActive;
  final int? timeLimit;
  final int questionsCount;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    this.description,
    required this.code,
    required this.isActive,
    this.timeLimit,
    this.questionsCount = 0,
    this.questions = const [],
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      code: json['code'],
      isActive: json['is_active'],
      timeLimit: json['time_limit'],
      questionsCount: json['questions_count'] ?? 0,
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((e) => Question.fromJson(e))
              .toList() ??
          [],
    );
  }
}
