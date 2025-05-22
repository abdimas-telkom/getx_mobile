import 'package:get/get.dart';
import '../controllers/student_quiz_controller.dart';

class StudentQuizBinding extends Bindings {
  @override
  void dependencies() {
    final quizId = Get.arguments as int;
    Get.lazyPut(() => StudentQuizController(quizId: quizId));
  }
}
