import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/teacher_add_questions_controller.dart';

class TeacherAddQuestionsView extends GetView<TeacherAddQuestionsController> {
  const TeacherAddQuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return WillPopScope(
      onWillPop: () async {
        // Ask controller whether we can pop
        return await c.confirmCancel();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Questions'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await c.confirmCancel()) {
                Get.back(result: c.count.value > 0);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: c.finishQuiz,
              child: const Text(
                'FINISH',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Obx(() {
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Quiz Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quiz: ${c.quizTitle}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Code: ${c.quizCode}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Questions added: ${c.count.value}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            if (c.count.value > 0)
                              TextButton.icon(
                                onPressed: c.finishQuiz,
                                icon: const Icon(Icons.check_circle),
                                label: const Text('FINISH QUIZ'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Question Form Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Question Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          onChanged: (v) => c.questionText.value = v,
                          decoration: const InputDecoration(
                            labelText: 'Enter Question',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Answer Options',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Option fields
                        ...List.generate(c.answers.length, (i) {
                          return Row(
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
                                  onChanged: (v) =>
                                      c.answers[i]['answer_text'] = v,
                                  decoration: InputDecoration(
                                    labelText: 'Option ${i + 1}',
                                    border: const OutlineInputBorder(),
                                    suffixIcon: c.answers.length > 2
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                            ),
                                            onPressed: () => c.removeOption(i),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        TextButton.icon(
                          onPressed: c.addOption,
                          icon: const Icon(Icons.add_circle),
                          label: const Text('Add Option'),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: c.saveQuestion,
                          icon: const Icon(Icons.save),
                          label: const Text('SAVE QUESTION'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
