import 'package:get/get.dart';

import '../controllers/teacher_add_questions_controller.dart';

class TeacherAddQuestionsBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>;
    Get.lazyPut<TeacherAddQuestionsController>(
      () => TeacherAddQuestionsController(
        quizId: args['quizId'],
        quizTitle: args['quizTitle'],
        quizCode: args['quizCode'],
      ),
    );
  }
}
