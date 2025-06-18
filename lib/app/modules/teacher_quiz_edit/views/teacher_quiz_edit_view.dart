import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/models/question_type.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/form_field_with_label.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/Youtube_forms.dart';
import '../controllers/teacher_quiz_edit_controller.dart';

class TeacherQuizEditView extends GetView<TeacherQuizEditController> {
  const TeacherQuizEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // REMOVED Obx wrapper here, as controller.isNew is not an observable.
        title: Text(
          controller.isNew ? 'Tambah Soal Baru' : 'Edit Soal',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: whiteColor,
        foregroundColor: blackColor,
        elevation: 0,
        centerTitle: true,
      ),
      // This Obx is CORRECT because it observes a reactive variable (.isSubmitting.value)
      body: Obx(
        () => controller.isSubmitting.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCommonDetailsSection(context),
                    const SizedBox(height: 24),
                    _buildAnswerOptionsSection(context),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: controller.save,
                      // REMOVED Obx wrapper here as well.
                      child: Text(
                        controller.isNew ? 'Simpan Soal' : 'Simpan Perubahan',
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  /// Builds the top section for Question Text, Points, and Type.
  Widget _buildCommonDetailsSection(BuildContext context) {
    final questionTypeNames = {
      QuestionType.multipleChoiceSingle: 'Pilihan Ganda Satu Jawaban',
      QuestionType.multipleChoiceMultiple: 'Pilihan Ganda Beberapa Jawaban',
      QuestionType.trueFalse: 'Benar atau Salah',
      QuestionType.weightedOptions: 'Pilihan Berbobot',
      QuestionType.matching: 'Pasangan',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldWithLabel(
          label: 'Pertanyaan',
          child: TextFormField(
            initialValue: controller.questionText.value,
            onChanged: (v) => controller.questionText.value = v,
            decoration: InputDecoration(hintText: 'Masukkan teks pertanyaan'),
            maxLines: 3,
          ),
        ),
        const SizedBox(height: 16),
        FormFieldWithLabel(
          label: 'Poin Soal',
          child: TextFormField(
            initialValue: controller.points.value.toString(),
            onChanged: (v) => controller.points.value = int.tryParse(v) ?? 10,
            decoration: InputDecoration(hintText: 'Masukkan Poin'),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(height: 16),
        FormFieldWithLabel(
          label: 'Tipe Soal',
          // This Obx is CORRECT because it observes a reactive variable (.selectedQuestionType.value)
          child: Obx(
            () => DropdownButtonFormField<QuestionType>(
              value: controller.selectedQuestionType.value,
              onChanged: controller.isNew
                  ? (v) {
                      if (v != null) {
                        controller.selectedQuestionType.value = v;
                      }
                    }
                  : null,
              items: QuestionType.values
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(questionTypeNames[type]!),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the section for answer options, which changes based on question type.
  Widget _buildAnswerOptionsSection(BuildContext context) {
    // This Obx is CORRECT
    return Obx(() {
      final type = controller.selectedQuestionType.value;
      final showAddButton =
          type == QuestionType.multipleChoiceSingle ||
          type == QuestionType.multipleChoiceMultiple ||
          type == QuestionType.weightedOptions;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Opsi Jawaban', style: formLabel),
              if (showAddButton)
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    switch (type) {
                      case QuestionType.multipleChoiceSingle:
                      case QuestionType.multipleChoiceMultiple:
                        controller.addMcOption();
                        break;
                      case QuestionType.weightedOptions:
                        controller.addWeightedOption();
                        break;
                      default:
                    }
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          // This Obx is also CORRECT
          Obx(() {
            switch (controller.selectedQuestionType.value) {
              case QuestionType.multipleChoiceSingle:
                return buildMultipleChoiceForm(
                  controller: controller,
                  isSingleChoice: true,
                );
              case QuestionType.multipleChoiceMultiple:
                return buildMultipleChoiceForm(
                  controller: controller,
                  isSingleChoice: false,
                );
              case QuestionType.trueFalse:
                return buildTrueFalseForm(controller: controller);
              case QuestionType.weightedOptions:
                return buildWeightedOptionsForm(controller: controller);
              case QuestionType.matching:
                return buildMatchingForm(controller: controller);
            }
          }),
        ],
      );
    });
  }
}
