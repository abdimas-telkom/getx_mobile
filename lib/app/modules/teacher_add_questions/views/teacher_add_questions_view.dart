import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/models/question_type.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/form_field_with_label.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/Youtube_forms.dart';
import '../controllers/teacher_add_questions_controller.dart';

class TeacherAddQuestionsView extends GetView<TeacherAddQuestionsController> {
  const TeacherAddQuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    // A map for user-friendly dropdown names
    final questionTypeNames = {
      QuestionType.multipleChoiceSingle: 'Pilihan Ganda Satu Jawaban',
      QuestionType.multipleChoiceMultiple: 'Pilihan Ganda Beberapa Jawaban',
      QuestionType.trueFalse: 'Benar atau Salah',
      QuestionType.weightedOptions: 'Pilihan Berbobot',
      QuestionType.matching: 'Pasangan',
    };

    // Define the specific input decoration for this screen
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

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (await controller.confirmCancel()) {
          Get.back(result: controller.questionCount.value > 0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tambah Soal',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: whiteColor,
          foregroundColor: blackColor,
          elevation: 0,
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: controller.finishQuiz,
              child: const Text('SELESAI'),
            ),
          ],
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildQuizInfoCard(),
                      const SizedBox(height: 24),
                      _buildQuestionForm(inputDecoration, questionTypeNames),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: controller.saveQuestion,
                        child: const Text('Tambah Soal Ini'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildQuizInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Judul: ${controller.quizTitle}', style: cardSubtitle),
          const SizedBox(height: 4),
          Text('Kode: ${controller.quizCode}', style: cardSubtitle),
          const SizedBox(height: 4),
          Obx(
            () => Text(
              'Jumlah Pertanyaan: ${controller.questionCount.value}',
              style: cardSubtitle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionForm(
    InputDecoration inputDecoration,
    Map<QuestionType, String> names,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldWithLabel(
          label: 'Pertanyaan',
          child: TextFormField(
            onChanged: (v) => controller.questionText.value = v,
            decoration: inputDecoration.copyWith(
              hintText: 'Masukkan teks pertanyaan',
            ),
            maxLines: 3,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: controller.points.value.toString(),
          onChanged: (v) => controller.points.value = int.tryParse(v) ?? 0,
          decoration: inputDecoration.copyWith(
            labelText: 'Poin Maksimal untuk Soal ini',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        Text(
          'Ubah jika soal ini punya bobot lebih tinggi dari yang lain',
          style: cardSubtitle.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<QuestionType>(
          value: controller.selectedQuestionType.value,
          decoration: inputDecoration,
          items: QuestionType.values
              .map(
                (type) =>
                    DropdownMenuItem(value: type, child: Text(names[type]!)),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) controller.onQuestionTypeChanged(v);
          },
        ),
        const SizedBox(height: 24),

        // --- DYNAMIC ANSWER OPTIONS ---
        _buildAnswerOptionsSection(inputDecoration),
      ],
    );
  }

  Widget _buildAnswerOptionsSection(InputDecoration inputDecoration) {
    return Obx(() {
      final type = controller.selectedQuestionType.value;
      // Determine if the add button should be shown
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
          // This Obx will rebuild only the answer form when the type changes
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
