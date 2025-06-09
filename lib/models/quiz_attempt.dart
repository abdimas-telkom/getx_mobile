// models/quiz_attempt.dart

class QuizAttempt {
  // ... (Your properties and constructor remain the same) ...
  final int id;
  final int quizId;
  final int? userId;
  final double score;
  final int totalQuestions;
  final String createdAt;
  final String? completedAt;
  final AttemptUser? user;
  final AttemptQuizInfo? quiz;

  // Add the status getter here as well
  String get status {
    if (completedAt != null) {
      return 'Completed';
    }
    return 'In Progress';
  }

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.createdAt,
    this.completedAt,
    this.user,
    this.quiz,
  });

  // --- REFACTORED FACTORY CONSTRUCTOR ---
  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      // Use the null-coalescing operator '??' to provide a default value if the API sends null
      id: json['id'] ?? 0,
      quizId: json['quiz_id'] ?? 0,
      userId: json['user_id'], // This is already nullable, so it's safe
      
      // Make the score parsing safer
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      
      totalQuestions: json['total_questions'] ?? 0,
      
      // This is the most likely source of your error. If createdAt is null, default to an empty string.
      createdAt: json['created_at'] ?? '', 
      
      completedAt: json['completed_at'], // This is already nullable, so it's safe
      
      // This logic is already null-safe
      user: json['user'] != null ? AttemptUser.fromJson(json['user']) : null,
      quiz: json['quiz'] != null ? AttemptQuizInfo.fromJson(json['quiz']) : null,
    );
  }
}

// ... (The AttemptUser and AttemptQuizInfo classes remain the same) ...

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

class AttemptQuizInfo {
  final int id;
  final String title;
  final String? description;

  AttemptQuizInfo({required this.id, required this.title, this.description});

  factory AttemptQuizInfo.fromJson(Map<String, dynamic> json) {
    return AttemptQuizInfo(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Quiz',
      description: json['description'],
    );
  }
}