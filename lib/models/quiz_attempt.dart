import 'package:intl/intl.dart';

class QuizAttempt {
  final int id;
  final int quizId;
  final String status;
  final double score;
  final String startTime;
  final DateTime? completedAt;
  final String studentName;

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.status,
    required this.score,
    required this.startTime,
    this.completedAt,
    required this.studentName,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }

    // A safer way to extract the student's name
    String getStudentName(dynamic userData) {
      if (userData is Map<String, dynamic> && userData.containsKey('name')) {
        return userData['name'];
      }
      return 'Siswa tidak dikenal';
    }

    return QuizAttempt(
      id: json['id'] ?? 0,
      quizId: json['quiz_id'] ?? 0,
      status: json['status'] == 'Completed' ? 'finished' : 'in_progress',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      startTime: DateFormat(
        'd MMMM yyyy – HH:mm',
        'id_ID',
      ).format(DateTime.parse(json['created_at'])),
      completedAt: parseDate(json['completed_at']),
      // Use the safer helper function here
      studentName: getStudentName(json['user']),
    );
  }
}
