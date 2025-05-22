import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/quiz_details_header_controller.dart';

class QuizDetailsHeaderView extends GetView<QuizDetailsHeaderController> {
  const QuizDetailsHeaderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quiz Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Obx(
                  () => c.isEditing.value
                      ? (c.isUpdating.value
                            ? const CircularProgressIndicator()
                            : IconButton(
                                icon: const Icon(Icons.save),
                                onPressed: c.saveChanges,
                              ))
                      : IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: c.toggleEdit,
                        ),
                ),
              ],
            ),
            const Divider(),
            Obx(() {
              if (c.isEditing.value) {
                return Column(
                  children: [
                    TextField(
                      controller: c.titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: c.descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: c.codeController,
                      decoration: const InputDecoration(labelText: 'Code'),
                    ),
                  ],
                );
              }
              final data = c.quizData.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title: ${data['title']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if ((data['description'] ?? '').isNotEmpty)
                    Text('Description: ${data['description']}'),
                  Text('Code: ${data['code']}'),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
