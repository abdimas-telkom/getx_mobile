import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

import '../controllers/student_dashboard_controller.dart';

class StudentDashboardView extends GetView<StudentDashboardController> {
  const StudentDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', height: 40),
                  const SizedBox(width: 12),
                  Text('SDN 227 Margahayu Utara', style: textTheme.titleMedium),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: controller.logout,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Obx(
                () => Text(
                  'Selamat datang, ${controller.studentName.value}!',
                  style: textTheme.displaySmall,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                'Silakan masukan kode untuk mengakses soal kuis.',
                style: bodyRegular,
              ),
              const SizedBox(height: 24),

              TextField(
                controller: controller.codeController,
                textAlign: TextAlign.center,
                style: inputText.copyWith(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Kode',
                  hintStyle: inputLabel,
                ),
              ),
              const SizedBox(height: 8),

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
