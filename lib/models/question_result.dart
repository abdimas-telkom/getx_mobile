class QuestionResult {
  final String questionText;
  final String questionType;
  final int points;
  final int earnedPoints;
  final bool isCorrect;
  final dynamic userAnswer;
  final dynamic correctAnswer;

  QuestionResult({
    required this.questionText,
    required this.questionType,
    required this.points,
    required this.earnedPoints,
    required this.isCorrect,
    this.userAnswer,
    this.correctAnswer,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    dynamic userAnswer;
    dynamic correctAnswer;

    switch (json['question_type']) {
      case 'multiple_choice_multiple':
        userAnswer = List<String>.from(json['user_answers'] ?? []);
        correctAnswer = List<String>.from(json['correct_answers'] ?? []);
        break;
      case 'matching':
        userAnswer = List<Map<String, dynamic>>.from(
          json['user_matching'] ?? [],
        );
        correctAnswer = List<Map<String, dynamic>>.from(
          json['correct_matching'] ?? [],
        );
        break;
      default:
        userAnswer = json['user_answer'];
        correctAnswer = json['correct_answer'];
    }

    return QuestionResult(
      questionText: json['question_text'] ?? 'No question text',
      questionType: json['question_type'] ?? 'unknown',
      points: json['points'] ?? 0,
      earnedPoints: json['earned_points'] ?? 0,
      isCorrect: json['is_correct'] ?? false,
      userAnswer: userAnswer,
      correctAnswer: correctAnswer,
    );
  }
}
