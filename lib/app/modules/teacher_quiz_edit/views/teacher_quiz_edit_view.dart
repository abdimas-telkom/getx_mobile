import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/teacher_quiz_edit_controller.dart';

class TeacherQuizEditView extends GetView<TeacherQuizEditController> {
  const TeacherQuizEditView({super.key});
  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(c.isNew ? 'Add Question' : 'Edit Question')),
        actions: [
          Obx(
            () => c.isSubmitting.value
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : TextButton(
                    onPressed: c.save,
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (v) => c.questionText.value = v,
              controller: TextEditingController(text: c.questionText.value),
              decoration: const InputDecoration(
                labelText: 'Question Text',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Obx(
              () => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Answers',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: c.addOption,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  ...List.generate(c.answers.length, (i) {
                    final ans = c.answers[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
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
                              onChanged: (v) => ans['answer_text'] = v,
                              decoration: InputDecoration(
                                hintText: 'Option ${i + 1}',
                                border: const OutlineInputBorder(),
                              ),
                              controller: TextEditingController(
                                text: ans['answer_text'],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => c.removeOption(i),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
