import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/student_dashboard_controller.dart';

class StudentDashboardView extends GetView<StudentDashboardController> {
  const StudentDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudentDashboardView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StudentDashboardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
