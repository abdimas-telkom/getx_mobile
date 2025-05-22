// File: models/quiz_attempt.dart
class QuizAttempt {
  final int id;
  final int quizId;
  final String studentName;
  final String status; // 'completed', 'in_progress', or 'abandoned'
  final int rawScore; // Number of correct answers
  final int score;    // Percentage score out of 100
  final int totalQuestions;
  final String startedAt;
  final String? completedAt;
  
  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.studentName,
    required this.status,
    required this.rawScore,
    required this.score,
    required this.totalQuestions,
    required this.startedAt,
    this.completedAt,
  });
  
  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      quizId: json['quiz_id'] is String ? int.parse(json['quiz_id']) : json['quiz_id'] as int,
      studentName: json['student_name'] as String,
      status: json['status'] as String,
      rawScore: json['raw_score'] is String ? int.parse(json['raw_score']) : (json['raw_score'] ?? 0) as int,
      score: json['score'] is String ? int.parse(json['score']) : (json['score'] ?? 0) as int,
      totalQuestions: json['total_questions'] is String ? int.parse(json['total_questions']) : (json['total_questions'] ?? 0) as int,
      startedAt: json['started_at'] as String,
      completedAt: json['completed_at'] as String?,
    );
  }
}