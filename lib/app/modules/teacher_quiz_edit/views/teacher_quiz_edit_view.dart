import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/teacher_quiz_edit_controller.dart';

class TeacherQuizEditView extends GetView<TeacherQuizEditController> {
  const TeacherQuizEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return Scaffold(
      appBar: AppBar(title: Text(c.isNew ? 'New Question' : 'Edit Question')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              initialValue: c.questionText.value,
              decoration: const InputDecoration(labelText: 'Question'),
              onChanged: c.questionText,
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: c.answers.length,
                  itemBuilder: (ctx, i) {
                    final answer = c.answers[i];
                    return ListTile(
                      title: TextFormField(
                        initialValue: answer['answer_text'],
                        decoration: InputDecoration(
                          labelText: 'Option ${i + 1}',
                        ),
                        onChanged: (v) {
                          answer['answer_text'] = v;
                          c.answers.refresh();
                        },
                      ),
                      leading: Radio<int>(
                        value: i,
                        groupValue: c.correctIndex.value,
                        onChanged: (sel) {
                          if (sel != null) c.selectCorrect(sel);
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => c.removeOption(i),
                      ),
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: c.addOption,
                icon: const Icon(Icons.add),
                label: const Text('Add option'),
              ),
            ),

            const SizedBox(height: 16),

            Obx(() {
              return ElevatedButton(
                onPressed: c.isSubmitting.value ? null : c.save,
                child: c.isSubmitting.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(c.isNew ? 'Create' : 'Update'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
