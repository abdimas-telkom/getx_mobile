import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/services/teacher_quiz_service.dart';

class TeacherQuizEditController extends GetxController {
  final int quizId;
  final Map<String, dynamic>? questionData;

  TeacherQuizEditController({required this.quizId, this.questionData});

  final questionText = ''.obs;
  final answers = <Map<String, dynamic>>[].obs;
  final correctIndex = Rxn<int>();
  final isSubmitting = false.obs;

  bool get isNew => questionData == null;

  @override
  void onInit() {
    super.onInit();
    if (questionData != null) {
      questionText.value = questionData!['question_text'] ?? '';
      final list = List<Map<String, dynamic>>.from(
        questionData!['answers'] as List,
      );
      answers.assignAll(
        list.map(
          (a) => {
            'id': a['id'],
            'answer_text': a['answer_text'],
            'is_correct': a['is_correct'] ?? false,
          },
        ),
      );
      for (var i = 0; i < answers.length; i++) {
        if (answers[i]['is_correct'] == true) {
          correctIndex.value = i;
          break;
        }
      }
    } else {
      answers.assignAll([
        {'answer_text': '', 'is_correct': true},
        {'answer_text': '', 'is_correct': false},
      ]);
      correctIndex.value = 0;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void addOption() {
    answers.add({'answer_text': '', 'is_correct': false});
  }

  void removeOption(int idx) {
    if (answers.length <= 2) return;
    answers.removeAt(idx);
    if (correctIndex.value != null) {
      if (correctIndex.value == idx)
        correctIndex.value = null;
      else if (correctIndex.value! > idx)
        correctIndex.value = correctIndex.value! - 1;
    }
  }

  void selectCorrect(int idx) {
    correctIndex.value = idx;
    for (var i = 0; i < answers.length; i++) {
      answers[i]['is_correct'] = i == idx;
    }
    answers.refresh();
  }

  Future<void> save() async {
    if (questionText.value.trim().isEmpty) return;
    if (correctIndex.value == null) return;
    isSubmitting.value = true;
    final payload = answers
        .map(
          (a) => {
            'answer_text': a['answer_text'],
            'is_correct': a['is_correct'],
          },
        )
        .toList();

    try {
      if (isNew) {
        await TeacherQuizService.addQuestion(
          quizId,
          questionText.value,
          payload,
        );
      } else {
        await TeacherQuizService.updateQuestion(
          quizId,
          questionData!['id'] as int,
          questionText.value,
          payload,
        );
      }
      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
}
