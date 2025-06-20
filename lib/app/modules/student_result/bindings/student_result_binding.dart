import 'package:get/get.dart';

import '../controllers/student_result_controller.dart';

class StudentResultBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>;
    Get.lazyPut(
      () => StudentResultController(
        attemptId: args['attemptId'],
        isGuru: args['isGuru'],
      ),
    );
  }
}
