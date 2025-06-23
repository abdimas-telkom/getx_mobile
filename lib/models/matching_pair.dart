class MatchingPair {
  final int? id;
  String prompt;
  String correctAnswer;

  MatchingPair({this.id, required this.prompt, required this.correctAnswer});

  factory MatchingPair.fromJson(Map<String, dynamic> json) {
    return MatchingPair(
      id: json['id'],
      prompt: json['prompt'],
      correctAnswer: json['correct_answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'prompt': prompt,
      'correct_answer': correctAnswer,
    };
  }
}
