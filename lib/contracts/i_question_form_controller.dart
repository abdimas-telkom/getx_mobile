import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/models/question_type.dart';

/// An interface that defines the required members for any controller
/// that wants to use the shared question answer form widgets.
abstract class IQuestionFormController {
  // --- STATE PROPERTIES ---
  RxList<Map<String, dynamic>> get mcAnswers;
  RxBool get tfCorrectAnswer;
  RxList<Map<String, dynamic>> get weightedAnswers;
  RxList<Map<String, dynamic>> get matchingPairs;
  RxList<Map<String, dynamic>> get distractorAnswers;
  Rx<QuestionType> get selectedQuestionType;

  // --- METHODS ---
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
