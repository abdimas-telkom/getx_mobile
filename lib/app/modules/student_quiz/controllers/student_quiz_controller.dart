// lib/app/modules/student_quiz/controllers/student_quiz_controller.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/models/question.dart';
import 'package:ujian_sd_babakan_ciparay/models/question_type.dart';
import 'package:ujian_sd_babakan_ciparay/services/student_quiz_service.dart';

class StudentQuizController extends GetxController {
  final int quizId;
  late final int initialTimeLimit;
  StudentQuizController({required this.quizId});

  // --- STATE ---
  var isLoading = true.obs;
  var isSubmitting = false.obs;
  var questions = <Question>[].obs;
  var currentIndex = 0.obs;
  var userAnswers = <int, dynamic>{}.obs;

  // --- TIMER STATE ---
  late Timer _timer;
  var remainingSeconds = 0.obs;
  var timerString = ''.obs;

  // *** NEW: The authoritative time when the quiz ends. ***
  DateTime? deadline;

  // --- PERSISTENCE KEY ---
  String get _persistenceKey => 'quiz_state_$quizId';

  Question get currentQuestion => questions[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as List?;
    initialTimeLimit =
        (arguments != null && arguments.length > 1 && arguments[1] is int)
        ? arguments[1] as int
        : 0;
    loadQuestionsAndState();
  }

  @override
  void onClose() {
    _timer.cancel();
    // No need to save state on close, as the deadline is fixed.
    super.onClose();
  }

  Future<void> loadQuestionsAndState() async {
    isLoading.value = true;
    try {
      questions.assignAll(await StudentQuizService.getQuestions(quizId));
      await _loadState();
    } catch (e) {
      Get.snackbar('Error', 'Tidak dapat memuat kuis: ${e.toString()}');
      // If loading fails, establish a new deadline to start fresh.
      if (initialTimeLimit > 0) {
        deadline = DateTime.now().add(Duration(minutes: initialTimeLimit));
        await _saveState(); // Save the new deadline
      }
    } finally {
      // Start the timer which will now calculate time against the deadline.
      _startTimer();
      isLoading.value = false;
    }
  }

  // --- PERSISTENCE METHODS ---

  /// Saves the deadline and user answers.
  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodableAnswers = userAnswers.map((key, value) {
        return MapEntry(key.toString(), value);
      });
      final state = {
        // *** MODIFIED: Store the deadline, not the remaining seconds. ***
        'deadline': deadline?.toIso8601String(),
        'answers': encodableAnswers,
      };
      await prefs.setString(_persistenceKey, jsonEncode(state));
    } catch (e) {
      print("Error saving quiz state: $e");
    }
  }

  /// Loads the deadline and answers. If no deadline exists, it creates one.
  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStateString = prefs.getString(_persistenceKey);

    if (savedStateString != null) {
      final savedState = jsonDecode(savedStateString) as Map<String, dynamic>;
      final deadlineString = savedState['deadline'] as String?;
      final savedAnswers = savedState['answers'] as Map<String, dynamic>?;

      if (deadlineString != null) {
        deadline = DateTime.tryParse(deadlineString);
      }

      if (savedAnswers != null) {
        final convertedAnswers = savedAnswers.map((key, value) {
          return MapEntry(int.parse(key), value);
        });
        userAnswers.clear();
        userAnswers.addAll(convertedAnswers);
      }
    }

    // *** NEW: If no deadline was loaded (e.g., first time taking quiz), create one.
    if (deadline == null && initialTimeLimit > 0) {
      deadline = DateTime.now().add(Duration(minutes: initialTimeLimit));
      // Save the state immediately so the new deadline is persisted.
      await _saveState();
    }
  }

  Future<void> _clearState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_persistenceKey);
  }

  // --- TIMER LOGIC ---

  /// The timer now calculates remaining time against the fixed deadline.
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // If deadline hasn't been set, do nothing.
      if (deadline == null) {
        remainingSeconds.value = 0;
        _updateTimerString();
        timer.cancel();
        return;
      }

      // Calculate the difference between now and the deadline.
      final remaining = deadline!.difference(DateTime.now());

      if (remaining.inSeconds > 0) {
        remainingSeconds.value = remaining.inSeconds;
      } else {
        // *** NEW: Time has run out! ***
        remainingSeconds.value = 0;
        timer.cancel(); // Stop the timer

        // Notify the user and force submit the quiz.
        if (!Get.isSnackbarOpen) {
          Get.snackbar(
            "Waktu Habis",
            "Ujian akan dikirim secara otomatis.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
        submit(force: true);
      }
      _updateTimerString();
    });
  }

  void _updateTimerString() {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    timerString.value =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // --- ANSWER SELECTION METHODS (No changes needed) ---
  void selectSingleAnswer(int questionId, int answerId) {
    userAnswers[questionId] = answerId;
    _saveState();
  }

  void toggleMultiAnswer(int questionId, int answerId) {
    final List<int> currentSelections = List<int>.from(
      userAnswers[questionId] ?? [],
    );
    if (currentSelections.contains(answerId)) {
      currentSelections.remove(answerId);
    } else {
      currentSelections.add(answerId);
    }
    userAnswers[questionId] = currentSelections;
    _saveState();
  }

  void selectMatchingAnswer(
    int questionId,
    String prompt,
    String selectedAnswer,
  ) {
    final List<Map<String, String>> currentPairs =
        List<Map<String, String>>.from(userAnswers[questionId] ?? []);
    final int existingIndex = currentPairs.indexWhere(
      (p) => p['prompt'] == prompt,
    );

    if (existingIndex != -1) {
      currentPairs[existingIndex]['selected_answer'] = selectedAnswer;
    } else {
      currentPairs.add({'prompt': prompt, 'selected_answer': selectedAnswer});
    }
    userAnswers[questionId] = currentPairs;
    _saveState();
  }

  // --- NAVIGATION ---
  /// Jumps the view to a specific question index.
  void jumpToQuestion(int index) {
    if (index >= 0 && index < questions.length) {
      currentIndex.value = index;
    }
  }

  void next() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
    } else {
      // User-initiated submission at the end of the quiz.
      submit();
    }
  }

  void previous() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  /// Submits the quiz. Can be forced by the timer even if incomplete.
  Future<void> submit({bool force = false}) async {
    // *** MODIFIED: If not a forced submission, check for completion. ***
    if (!force && userAnswers.length != questions.length) {
      Get.snackbar(
        'Belum Selesai',
        'Harap jawab semua pertanyaan sebelum mengirim.',
      );
      return;
    }

    isSubmitting.value = true;
    _timer.cancel();

    // Payload construction remains the same
    final List<Map<String, dynamic>> finalPayload = [];
    for (var question in questions) {
      final questionId = question.id;
      final answerData = userAnswers[questionId];
      final Map<String, dynamic> answerPayload = {'question_id': questionId};
      switch (question.questionType) {
        case QuestionType.multipleChoiceSingle:
        case QuestionType.trueFalse:
        case QuestionType.weightedOptions:
          answerPayload['answer_id'] = answerData;
          break;
        case QuestionType.multipleChoiceMultiple:
          answerPayload['answer_ids'] = answerData;
          break;
        case QuestionType.matching:
          answerPayload['matching_pairs'] = answerData;
          break;
      }
      finalPayload.add(answerPayload);
    }

    try {
      final res = await StudentQuizService.submitAnswers(quizId, finalPayload);
      await _clearState();
      Get.offNamed(
        Routes.STUDENT_RESULT,
        arguments: {'attemptId': res['attempt_id'], 'isGuru': false},
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim ujian: ${e.toString()}');
      _startTimer();
    } finally {
      isSubmitting.value = false;
    }
  }
}
