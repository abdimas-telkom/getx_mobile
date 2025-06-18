import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

import '../controllers/student_dashboard_controller.dart';

class StudentDashboardView extends GetView<StudentDashboardController> {
  const StudentDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    // Access theme for specific text styles
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // No AppBar as per the new design
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50), // Space from top
              // Header Row with Logo and School Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Your logo path
                    height: 40,
                  ),
                  const SizedBox(width: 12),
                  // Using headingSection style from text_styles.dart via the theme
                  Text('SDN 227 Margahayu Utara', style: textTheme.titleMedium),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: controller.logout,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Greeting Text, observing the studentName from the controller
              Obx(
                () => Text(
                  'Hallo, ${controller.studentName.value}!',
                  // Using headingDisplay style from text_styles.dart via the theme
                  style: textTheme.displaySmall,
                ),
              ),
              const SizedBox(height: 8),

              // Instruction Text
              const Text(
                'Silakan masukan kode untuk mengakses soal kuis.',
                // Using bodyRegular style from text_styles.dart via the theme
                style: bodyRegular,
              ),
              const SizedBox(height: 24),

              // Code Input Field
              TextField(
                controller: controller.codeController,
                textAlign: TextAlign.center,
                // Using inputText style for the actual text entered
                style: inputText.copyWith(fontSize: 18),
                // Decoration is inherited from the theme, we just override the hint
                decoration: const InputDecoration(
                  hintText: 'Kode',
                  // Using inputLabel style for the hint, but centered
                  hintStyle: inputLabel,
                ),
              ),
              const SizedBox(height: 8),

              // Error Message Display
              Obx(() {
                if (controller.errorMessage.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Center(
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return const SizedBox(height: 24);
              }),
              const SizedBox(height: 8),

              // "Mulai" Button
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.joinQuiz,
                    // Style is inherited from the theme
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text('Mulai'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
