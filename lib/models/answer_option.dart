class AnswerOption {
  final int? id;
  late final String answerText;
  final bool? isCorrect;
  late final double? points;

  AnswerOption({
    this.id,
    required this.answerText,
    this.isCorrect,
    this.points,
  });

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      id: json['id'],
      answerText: json['answer_text'] ?? '',
      isCorrect: json['is_correct'],
      points: (json['points'] as num?)?.toDouble(),
    );
  }

  /// Converts the object to a JSON map for the API.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'answer_text': answerText};
    if (id != null) {
      data['id'] = id;
    }
    if (isCorrect != null) {
      data['is_correct'] = isCorrect;
    }
    if (points != null) {
      // *** FIX: Send points as an integer if it's a whole number. ***
      data['points'] = points == points!.roundToDouble()
          ? points!.toInt()
          : points;
    }
    return data;
  }
}
