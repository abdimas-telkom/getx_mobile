import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/teacher_add_questions_controller.dart';

class TeacherAddQuestionsView extends GetView<TeacherAddQuestionsController> {
  const TeacherAddQuestionsView({super.key});
  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Questions'),
        leading: BackButton(
          onPressed: () => Get.back(result: c.count.value > 0),
        ),
        actions: [
          TextButton(
            onPressed: c.finish,
            child: const Text('FINISH', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value)
          return const Center(child: CircularProgressIndicator());
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text(
                'Quiz: ${c.quizTitle} (Code: ${c.quizCode})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Questions added: ${c.count.value}'),
              const SizedBox(height: 16),
              TextField(
                onChanged: (v) => c.questionText.value = v,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(
                c.answers.length,
                (i) => Row(
                  children: [
                    Obx(
                      () => Radio<int>(
                        value: i,
                        groupValue: c.correctIndex.value,
                        onChanged: (v) => c.selectCorrect(v!),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => c.answers[i]['answer_text'] = v,
                        decoration: InputDecoration(
                          hintText: 'Option ${i + 1}',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => c.removeOption(i),
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: c.addOption,
                icon: const Icon(Icons.add_circle),
                label: const Text('Add Option'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: c.saveQuestion,
                child: const Text('SAVE QUESTION'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
