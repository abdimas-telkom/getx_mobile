import 'package:ujian_sd_babakan_ciparay/models/question_result.dart';
import 'package:ujian_sd_babakan_ciparay/models/user.dart';

class QuizResult {
  final String quizTitle;
  final User student;
  final double score;
  final int totalPoints;
  final double percentage;
  final DateTime? completedAt;
  final List<QuestionResult> questions;

  QuizResult({
    required this.quizTitle,
    required this.student,
    required this.score,
    required this.totalPoints,
    required this.percentage,
    this.completedAt,
    required this.questions,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      return dateString != null ? DateTime.tryParse(dateString) : null;
    }

    return QuizResult(
      quizTitle: json['quiz_title'] ?? 'No Title',
      student: User.fromJson(json['student'] ?? {}),
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      totalPoints: json['total_points'] ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      completedAt: parseDate(json['completed_at']),
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((q) => QuestionResult.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
