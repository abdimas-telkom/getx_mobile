import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/question_list_controller.dart';

class QuestionListView extends GetView<QuestionListController> {
  const QuestionListView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Obx(() {
      if (c.questions.isEmpty) {
        return const Center(child: Text('No questions'));
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: c.questions.length,
        itemBuilder: (_, i) {
          final q = c.questions[i];
          return ListTile(title: Text(q['question_text']));
        },
      );
    });
  }
}
