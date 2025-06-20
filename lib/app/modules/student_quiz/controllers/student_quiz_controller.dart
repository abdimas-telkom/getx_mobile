import 'dart:async';

import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/services/student_quiz_service.dart';

class StudentQuizController extends GetxController {
  final int quizId;
  late final int initialTimeLimit;
  StudentQuizController({required this.quizId});

  // --- STATE ---
  var isLoading = true.obs;
  var isSubmitting = false.obs;

  // The list of question objects fetched from the API
  var questions = <Map<String, dynamic>>[].obs;

  // The current question index the user is viewing
  var currentIndex = 0.obs;

  // The flexible map to store user's answers.
  // Key: questionId, Value: the answer data (int, List<int>, List<Map>, etc.)
  var userAnswers = <int, dynamic>{}.obs;

  // Timer state
  late Timer _timer;
  var remainingSeconds = 0.obs;
  var timerString = ''.obs;

  // A computed property to get the current question
  Map<String, dynamic> get currentQuestion => questions[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    initialTimeLimit = Get.arguments[1] as int;
    remainingSeconds.value = initialTimeLimit * 60;
    _startTimer();
    loadQuestions();
  }

  void _startTimer() {
    _updateTimerString();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
        _updateTimerString();
      } else {
        // time’s up
        _timer.cancel();
        submit(); // auto-submit when out of time
      }
    });
  }

  void _updateTimerString() {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    timerString.value =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> loadQuestions() async {
    isLoading.value = true;
    try {
      final data = await StudentQuizService.getQuestions(quizId);
      questions.assignAll(List<Map<String, dynamic>>.from(data));
      // Initialize the answer map as empty. It will be populated as the user answers.
      userAnswers.clear();
    } catch (e) {
      Get.snackbar('Error', 'Could not load questions: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // --- ANSWER SELECTION METHODS ---

  /// For Single Choice, True/False, and Weighted Options
  void selectSingleAnswer(int questionId, int answerId) {
    userAnswers[questionId] = answerId;
  }

  /// For Multiple Choice (Multiple Answers)
  void toggleMultiAnswer(int questionId, int answerId) {
    // Get the current list of selected answers for this question, or start a new one.
    final List<int> currentSelections = List<int>.from(
      userAnswers[questionId] ?? [],
    );

    if (currentSelections.contains(answerId)) {
      currentSelections.remove(answerId);
    } else {
      currentSelections.add(answerId);
    }

    userAnswers[questionId] = currentSelections;
  }

  /// For Matching Questions
  void selectMatchingAnswer(
    int questionId,
    String prompt,
    String selectedAnswer,
  ) {
    final List<Map<String, String>> currentPairs =
        List<Map<String, String>>.from(userAnswers[questionId] ?? []);

    // Find if a pair with this prompt already exists
    final int existingIndex = currentPairs.indexWhere(
      (p) => p['prompt'] == prompt,
    );

    if (existingIndex != -1) {
      // Update existing pair
      currentPairs[existingIndex]['selected_answer'] = selectedAnswer;
    } else {
      // Add new pair
      currentPairs.add({'prompt': prompt, 'selected_answer': selectedAnswer});
    }

    userAnswers[questionId] = currentPairs;
  }

  // --- NAVIGATION ---

  void next() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
    } else {
      // If on the last question, "Next" becomes "Submit"
      submit();
    }
  }

  void previous() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  /// Builds the final payload and submits it to the API.
  Future<void> submit() async {
    // Client-side validation to ensure all questions have been answered.
    if (userAnswers.length != questions.length) {
      Get.snackbar(
        'Incomplete',
        'Please answer all questions before submitting.',
      );
      // Find the first unanswered question and navigate to it
      for (var i = 0; i < questions.length; i++) {
        if (!userAnswers.containsKey(questions[i]['id'])) {
          currentIndex.value = i;
          return;
        }
      }
      return;
    }

    isSubmitting.value = true;

    // --- PAYLOAD CONSTRUCTION ---
    final List<Map<String, dynamic>> finalPayload = [];

    for (var question in questions) {
      final questionId = question['id'];
      final questionType = question['question_type'];
      final answerData = userAnswers[questionId];

      final Map<String, dynamic> answerPayload = {'question_id': questionId};

      switch (questionType) {
        case 'multiple_choice_single':
        case 'true_false':
        case 'weighted_options':
          answerPayload['answer_id'] = answerData;
          break;
        case 'multiple_choice_multiple':
          answerPayload['answer_ids'] = answerData;
          break;
        case 'matching':
          answerPayload['matching_pairs'] = answerData;
          break;
      }
      finalPayload.add(answerPayload);
    }

    try {
      final res = await StudentQuizService.submitAnswers(quizId, finalPayload);
      Get.offNamed(
        Routes.STUDENT_RESULT,
        arguments: {'attemptId': res['attempt_id'], 'isGuru': false},
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit quiz: ${e.toString()}');
    } finally {
      isSubmitting.value = false;
    }
  }
}
