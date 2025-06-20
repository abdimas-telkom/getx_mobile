import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/student_result_controller.dart';

class StudentResultView extends GetView<StudentResultController> {
  const StudentResultView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Ujian'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value)
          return const Center(child: CircularProgressIndicator());
        final r = controller.results.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Nilai Anda',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (r['percentage'] as num).toDouble().toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text('${r['score']} dari ${r['total_points']} skor'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ...r['questions'].map<Widget>((q) {
                final correct = q['is_correct'] as bool;
                return Card(
                  color: correct ? Colors.green.shade50 : Colors.red.shade50,
                  child: ListTile(
                    leading: Icon(
                      correct ? Icons.check_circle : Icons.cancel,
                      color: correct ? Colors.green : Colors.red,
                    ),
                    title: Text(q['question_text']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jawaban anda: ${q['user_answer'] ?? '—'}'),
                        if (!correct)
                          Text('Jawaban benar : ${q['correct_answer']}'),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: controller.backHome,
                child: const Text('Kembali'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
