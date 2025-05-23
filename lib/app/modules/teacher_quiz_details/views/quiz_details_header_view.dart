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
                Obx(() {
                  if (c.isEditing.value) {
                    return c.isUpdating.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            icon: const Icon(Icons.save),
                            tooltip: 'Save Changes',
                            onPressed: c.saveChanges,
                          );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit Quiz',
                      onPressed: c.toggleEdit,
                    );
                  }
                }),
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
                    const SizedBox(height: 8),
                    Obx(
                      () => SwitchListTile(
                        title: const Text('Active'),
                        value: c.quizData.value['is_active'] ?? false,
                        onChanged: c.updateActiveStatus,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => TextFormField(
                        initialValue: (c.quizData.value['time_limit'] ?? '')
                            .toString(),
                        decoration: const InputDecoration(
                          labelText: 'Time Limit (min)',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: c.updateTimeLimit,
                      ),
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
                  if ((data['description'] ?? '').toString().isNotEmpty)
                    Text('Description: ${data['description']}'),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Code: ${data['code']}'),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          data['is_active'] == true
                              ? Icons.toggle_on
                              : Icons.toggle_off,
                          color: data['is_active'] == true
                              ? Colors.green
                              : Colors.grey,
                        ),
                        onPressed: c.toggleEdit,
                        tooltip: data['is_active'] == true
                            ? 'Deactivate'
                            : 'Activate',
                      ),
                    ],
                  ),
                  if ((data['time_limit'] ?? 0) > 0)
                    Text(
                      'Time limit: ${data['time_limit']} min',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
