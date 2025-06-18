/// Defines the different types of questions available in the quiz.
enum QuestionType {
  multipleChoiceSingle,
  multipleChoiceMultiple,
  trueFalse,
  weightedOptions,
  matching,
}

/// Provides helper extensions for the [QuestionType] enum.
extension QuestionTypeExtension on QuestionType {
  /// The string representation of the enum value for API requests.
  String get value {
    switch (this) {
      case QuestionType.multipleChoiceSingle:
        return 'multiple_choice_single';
      case QuestionType.multipleChoiceMultiple:
        return 'multiple_choice_multiple';
      case QuestionType.trueFalse:
        return 'true_false';
      case QuestionType.weightedOptions:
        return 'weighted_options';
      case QuestionType.matching:
        return 'matching';
    }
  }

  /// A factory method to create a [QuestionType] from its string representation.
  static QuestionType fromString(String type) {
    switch (type) {
      case 'multiple_choice_single':
        return QuestionType.multipleChoiceSingle;
      case 'multiple_choice_multiple':
        return QuestionType.multipleChoiceMultiple;
      case 'true_false':
        return QuestionType.trueFalse;
      case 'weighted_options':
        return QuestionType.weightedOptions;
      case 'matching':
        return QuestionType.matching;
      default:
        // Fallback to a default type if the string is unknown
        return QuestionType.multipleChoiceSingle;
    }
  }
}
