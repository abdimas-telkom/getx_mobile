import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/student_result_controller.dart';

class StudentResultView extends GetView<StudentResultController> {
  const StudentResultView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudentResultView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StudentResultView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
