import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/app/modules/teacher_quiz_details/controllers/teacher_quiz_details_controller.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/form_field_with_label.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/switch_row.dart';
import '../controllers/quiz_details_header_controller.dart';

class QuizDetailsHeaderView extends GetView<QuizDetailsHeaderController> {
  const QuizDetailsHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    // We need the parent controller to display read-only info
    Get.find<TeacherQuizDetailsController>();
    return Obx(
      () => controller.isEditing.value
          ? _buildEditableInfoForm()
          : _buildReadOnlyInfoCard(),
    );
  }

  Widget _buildReadOnlyInfoCard() {
    // The source of truth for read-only data is the parent controller
    final parentController = Get.find<TeacherQuizDetailsController>();
    final quiz = parentController.quizData.value;

    // Show a loader or empty state if quiz data isn't available yet
    if (quiz == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final timeLimit = quiz.timeLimit ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Informasi Ujian', style: headingSection),
              IconButton(
                onPressed: controller.toggleEdit,
                icon: const Icon(Icons.edit_outlined, color: textMutedColor),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          const Text('Judul Ujian', style: formLabel),
          Text(quiz.title, style: bodyRegular),
          const SizedBox(height: 12),
          const Text('Deskripsi Ujian', style: formLabel),
          Text(
            quiz.description != null && quiz.description!.isNotEmpty
                ? quiz.description!
                : 'Tidak ada deskripsi.',
            style: bodyRegular,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Code : ${quiz.code}', style: formLabel),
                  if (timeLimit > 0)
                    Text('Batas Waktu : $timeLimit Menit', style: cardSubtitle),
                ],
              ),
              // Use the quiz.isActive for the read-only switch state
              Switch(
                value: quiz.isActive,
                onChanged: null, // Makes it read-only
                activeColor: primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableInfoForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Informasi Ujian', style: headingSection),
              Obx(
                () => controller.isUpdating.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        onPressed: controller.saveChanges,
                        icon: const Icon(
                          Icons.save_outlined,
                          color: primaryColor,
                        ),
                      ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          FormFieldWithLabel(
            label: 'Judul Ujian',
            child: TextFormField(controller: controller.titleController),
          ),
          const SizedBox(height: 16),
          FormFieldWithLabel(
            label: 'Deskripsi Ujian',
            child: TextFormField(
              controller: controller.descriptionController,
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 16),
          // Use the dedicated timeLimitController
          FormFieldWithLabel(
            label: 'Durasi Ujian (Menit)',
            child: TextFormField(
              controller: controller.timeLimitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: '0 for no limit'),
            ),
          ),
          const SizedBox(height: 16),
          // Bind the switch to the controller's `isActiveForEditing` observable
          Obx(
            () => SwitchRow(
              title: 'Aktifkan Ujian',
              subtitle: 'Murid bisa langsung masuk ketika kuis aktif',
              value: controller.isActiveForEditing.value,
              onChanged: (newValue) {
                controller.isActiveForEditing.value = newValue;
              },
            ),
          ),
        ],
      ),
    );
  }
}
