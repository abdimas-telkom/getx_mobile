import 'package:get/get.dart';

import 'package:ujian_sd_babakan_ciparay/app/modules/teacher_quiz_details/controllers/quiz_details_header_controller.dart';
import 'package:ujian_sd_babakan_ciparay/app/modules/teacher_quiz_details/controllers/question_list_controller.dart';

import '../controllers/teacher_quiz_details_controller.dart';

class TeacherQuizDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionListController>(() => QuestionListController());
    Get.lazyPut<QuizDetailsHeaderController>(
      () => QuizDetailsHeaderController(),
    );
    final id = Get.arguments as int;
    Get.lazyPut<TeacherQuizDetailsController>(
      () => TeacherQuizDetailsController(quizId: id),
    );
  }
}
