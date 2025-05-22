import 'package:get/get.dart';

import '../controllers/student_result_controller.dart';

class StudentResultBinding extends Bindings {
  @override
  void dependencies() {
    final attemptId = Get.arguments as int;
    Get.lazyPut(() => StudentResultController(attemptId: attemptId));
  }
}
