import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/teacher_quiz_create_controller.dart';

class TeacherQuizCreateView extends GetView<TeacherQuizCreateController> {
  const TeacherQuizCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Quiz')),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (v) => c.title.value = v,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (v) => c.description.value = v,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Custom Code'),
                subtitle: const Text(
                  'Create a memorable code for your students',
                ),
                value: c.useCustom.value,
                onChanged: (v) => c.useCustom.value = v,
              ),
              if (c.useCustom.value) ...[
                const SizedBox(height: 8),
                TextField(
                  onChanged: (v) => c.code.value = v,
                  decoration: const InputDecoration(
                    labelText: 'Code',
                    hintText: 'e.g., MATH101',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 8,
                ),
              ],
              const SizedBox(height: 16),
              TextField(
                onChanged: (v) => c.timeLimit.value = int.tryParse(v),
                decoration: const InputDecoration(
                  labelText: 'Time Limit (min)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Activate Quiz'),
                subtitle: const Text('Students can join if active'),
                value: c.isActive.value,
                onChanged: (v) => c.isActive.value = v,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: c.submit,
                child: const Text(
                  'Create Quiz',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
