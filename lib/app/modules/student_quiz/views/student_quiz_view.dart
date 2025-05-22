import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/student_quiz_controller.dart';

class StudentQuizView extends GetView<StudentQuizController> {
  const StudentQuizView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudentQuizView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StudentQuizView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
