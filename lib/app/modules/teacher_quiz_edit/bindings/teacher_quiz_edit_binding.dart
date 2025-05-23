import 'package:get/get.dart';

import '../controllers/teacher_quiz_edit_controller.dart';

class TeacherQuizEditBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>;
    Get.lazyPut<TeacherQuizEditController>(
      () => TeacherQuizEditController(
        quizId: args['quizId'] as int,
        questionData: args['questionData'],
      ),
    );
  }
}
