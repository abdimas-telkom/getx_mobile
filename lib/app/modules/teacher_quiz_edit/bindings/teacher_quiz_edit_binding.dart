import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/models/question.dart';

import '../controllers/teacher_quiz_edit_controller.dart';

class TeacherQuizEditBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    Get.lazyPut<TeacherQuizEditController>(
      () => TeacherQuizEditController(
        quizId: args['quizId'] as int,
        question: args['questionData'] as Question,
      ),
    );
  }
}
