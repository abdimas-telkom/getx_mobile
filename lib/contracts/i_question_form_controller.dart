import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/models/answer_option.dart';
import 'package:ujian_sd_babakan_ciparay/models/matching_pair.dart';
import 'package:ujian_sd_babakan_ciparay/models/question_type.dart';

abstract class IQuestionFormController {
  // --- STATE PROPERTIES ---
  // The interface now uses the same strongly-typed models as the controller.

  abstract Rx<QuestionType> selectedQuestionType;

  abstract RxList<AnswerOption> mcAnswers;

  abstract RxBool tfCorrectAnswer;

  abstract RxList<AnswerOption> weightedAnswers;

  abstract RxList<MatchingPair> matchingPairs;

  abstract RxList<AnswerOption> distractorAnswers;

  // --- UI HELPER METHODS ---
  // These method signatures are also updated for type safety.

  void addMcOption();
  void removeMcOption(int index);
  void setCorrectMcAnswer(int index);
  void toggleCorrectMcAnswer(int index, bool value);

  void addWeightedOption();
  void removeWeightedOption(int index);

  void addMatchingPair();
  void removeMatchingPair(int index);

  void addDistractor();
  void removeDistractor(int index);
}
