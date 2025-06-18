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
    final inputDecoration = InputDecoration(
      filled: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
    );

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
                    _buildCommonDetailsSection(context, inputDecoration),
                    const SizedBox(height: 24),
                    _buildAnswerOptionsSection(context, inputDecoration),
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
  Widget _buildCommonDetailsSection(
    BuildContext context,
    InputDecoration inputDecoration,
  ) {
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
            decoration: inputDecoration.copyWith(
              hintText: 'Masukkan teks pertanyaan',
            ),
            maxLines: 3,
          ),
        ),
        const SizedBox(height: 16),
        FormFieldWithLabel(
          label: 'Poin Soal',
          child: TextFormField(
            initialValue: controller.points.value.toString(),
            onChanged: (v) => controller.points.value = int.tryParse(v) ?? 10,
            decoration: inputDecoration.copyWith(hintText: 'Masukkan Poin'),
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
              decoration: inputDecoration,
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
  Widget _buildAnswerOptionsSection(
    BuildContext context,
    InputDecoration inputDecoration,
  ) {
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
                  inputDecoration: inputDecoration,
                );
              case QuestionType.multipleChoiceMultiple:
                return buildMultipleChoiceForm(
                  controller: controller,
                  isSingleChoice: false,
                  inputDecoration: inputDecoration,
                );
              case QuestionType.trueFalse:
                return buildTrueFalseForm(controller: controller);
              case QuestionType.weightedOptions:
                return buildWeightedOptionsForm(
                  controller: controller,
                  inputDecoration: inputDecoration,
                );
              case QuestionType.matching:
                return buildMatchingForm(
                  controller: controller,
                  inputDecoration: inputDecoration,
                );
            }
          }),
        ],
      );
    });
  }
}
