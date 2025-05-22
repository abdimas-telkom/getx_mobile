import 'package:get/get.dart';

class QuestionListController extends GetxController {
  final quizId = Get.arguments as int;
  final questions = RxList<dynamic>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.parameters;
    if (Get.arguments is Map) {
      questions.assignAll((Get.arguments as Map)['questions'] as List);
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

  void refreshList(List<dynamic> newQuestions) {
    questions.assignAll(newQuestions);
  }
}
