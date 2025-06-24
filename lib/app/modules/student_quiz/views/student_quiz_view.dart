import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/models/question.dart';
import 'package:ujian_sd_babakan_ciparay/models/question_type.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/question_navigation_drawer.dart';
import '../controllers/student_quiz_controller.dart';

class StudentQuizView extends GetView<StudentQuizController> {
  const StudentQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    const buttonText = TextStyle(color: primaryColor);

    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Image.asset('assets/images/logo.png', height: 40),
                const SizedBox(width: 12),
                const Text(
                  'SDN 227 Margahayu Utara',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
      endDrawer: const QuestionNavigationDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.questions.isEmpty) {
          return const Center(child: Text('No questions found for this quiz.'));
        }

        final question = controller.currentQuestion;

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Soal ${controller.currentIndex.value + 1}',
                        style: Get.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        controller.timerString.value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(question.questionText),
                  const SizedBox(height: 24),
                  Expanded(child: _buildQuestionBody(question)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controller.currentIndex.value > 0
                          ? ElevatedButton.icon(
                              onPressed: controller.previous,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: primaryColor),
                              ),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: primaryColor,
                              ),
                              label: const Text('Previous', style: buttonText),
                            )
                          : const SizedBox.shrink(),
                      ElevatedButton.icon(
                        onPressed: controller.next,
                        icon: controller.isSubmitting.value
                            ? Container(
                                width: 24,
                                height: 24,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Icon(
                                controller.currentIndex.value ==
                                        controller.questions.length - 1
                                    ? Icons.check
                                    : Icons.arrow_forward,
                              ),
                        label: Text(
                          controller.currentIndex.value ==
                                  controller.questions.length - 1
                              ? 'Submit'
                              : 'Next',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: -5,
              top:
                  MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).size.height / 2.5),
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_right_alt_rounded,
                    color: primaryColor,
                    size: 20,
                  ),
                  onPressed: () {
                    scaffoldKey.currentState?.openEndDrawer();
                  },
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 10,
                    top: 10,
                    bottom: 10,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildQuestionBody(Question question) {
    final questionType = question.questionType;

    switch (questionType) {
      case QuestionType.multipleChoiceSingle:
        return _buildMultipleChoiceUI(question, isSingleChoice: true);
      case QuestionType.multipleChoiceMultiple:
        return _buildMultipleChoiceUI(question, isSingleChoice: false);
      case QuestionType.trueFalse:
        return _buildMultipleChoiceUI(question, isSingleChoice: true);
      case QuestionType.weightedOptions:
        return _buildMultipleChoiceUI(question, isSingleChoice: true);
      case QuestionType.matching:
        return _buildMatchingUI(question);
    }
  }

  Widget _buildMultipleChoiceUI(
    Question question, {
    required bool isSingleChoice,
  }) {
    final questionId = question.id;
    final options = question.answers;

    return Obx(() {
      final dynamic selectedAnswer = controller.userAnswers[questionId];

      return ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final optionId = option.id;

          if (isSingleChoice) {
            return Card(
              child: RadioListTile<int>(
                title: Text(option.answerText),
                value: optionId as int,
                groupValue: selectedAnswer,
                onChanged: (value) {
                  if (value != null) {
                    controller.selectSingleAnswer(questionId, value);
                  }
                },
              ),
            );
          } else {
            final List<int> selectedIds = List<int>.from(selectedAnswer ?? []);
            return Card(
              child: CheckboxListTile(
                title: Text(option.answerText),
                value: selectedIds.contains(optionId),
                onChanged: (value) {
                  if (value != null) {
                    controller.toggleMultiAnswer(questionId, optionId!);
                  }
                },
              ),
            );
          }
        },
      );
    });
  }

  Widget _buildMatchingUI(Question question) {
    final questionId = question.id;

    final prompts = question.prompts;

    final answerOptions = question.distractorAnswers
        .map((opt) => opt.answerText)
        .toList();

    return Obx(() {
      final List<Map<String, String>> selectedPairs =
          List<Map<String, String>>.from(
            controller.userAnswers[questionId] ?? [],
          );

      return ListView.builder(
        itemCount: prompts.length,
        itemBuilder: (context, index) {
          final prompt = prompts[index];
          final currentSelection = selectedPairs.firstWhere(
            (pair) => pair['prompt'] == prompt,
            orElse: () => {'selected_answer': ''},
          )['selected_answer'];

          return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      prompt,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: currentSelection!.isEmpty
                          ? null
                          : currentSelection,
                      hint: const Text('Pilih Jawaban...'),
                      items: answerOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          controller.selectMatchingAnswer(
                            questionId,
                            prompt,
                            newValue,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
