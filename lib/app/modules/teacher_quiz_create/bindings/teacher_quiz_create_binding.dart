import 'package:get/get.dart';

import '../controllers/teacher_quiz_create_controller.dart';

class TeacherQuizCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherQuizCreateController>(
      () => TeacherQuizCreateController(),
    );
  }
}
