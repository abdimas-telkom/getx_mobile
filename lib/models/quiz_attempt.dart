// models/quiz_attempt.dart

import 'package:intl/intl.dart';

class QuizAttempt {
  final int id;
  final int quizId;
  final String status; // Use the status directly from the API
  final double score;
  final String startTime; // Make this nullable for safety
  final DateTime? completedAt; // Make this nullable for safety
  final String? studentName; // Add a direct property for the student's name

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.status,
    required this.score,
    required this.startTime,
    this.completedAt,
    this.studentName,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse dates that might be null
    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }

    return QuizAttempt(
      id: json['id'] ?? 0,
      quizId: json['quiz_id'] ?? 0,
      // Use the status from the API, with a fallback
      status: json['status'] == 'Completed' ? 'finished' : 'in_progress',
      // Safely parse the score, which might be an int or double
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      // Use the safe date parsing helper
      startTime: DateFormat(
        'd MMMM yyyy – HH:mm',
        'id_ID',
      ).format(DateTime.parse(json['created_at'])),
      completedAt: parseDate(json['completed_at']),
      // Extract the student name from the nested 'user' object
      studentName:
          (json['user'] as Map<String, dynamic>?)?['name'] ??
          'Siswa tidak dikenal',
    );
  }
}

// These nested models are not needed if you only need the student's name
// but are kept here for reference if you expand functionality later.
class AttemptUser {
  final int id;
  final String name;
  final String email;

  AttemptUser({required this.id, required this.name, required this.email});

  factory AttemptUser.fromJson(Map<String, dynamic> json) {
    return AttemptUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
    );
  }
}
