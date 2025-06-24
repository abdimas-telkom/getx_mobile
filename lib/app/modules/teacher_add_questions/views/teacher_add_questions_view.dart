import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          title: const Text('Tambah Soal'),
          elevation: 0,
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: controller.finishQuiz,
              child: const Text('Selesai'),
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
                      _buildQuestionForm(questionTypeNames),
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

  Widget _buildQuestionForm(Map<QuestionType, String> names) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldWithLabel(
          label: 'Pertanyaan',
          child: TextFormField(
            onChanged: (v) => controller.questionText.value = v,
            decoration: InputDecoration(hintText: 'Masukkan teks pertanyaan'),
            maxLines: 3,
          ),
          isRequired: true,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: controller.points.value.toString(),
          onChanged: (v) => controller.points.value = int.tryParse(v) ?? 0,
          decoration: InputDecoration(
            labelText: 'Poin Maksimal untuk Soal ini',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 8),
        Text(
          'Ubah jika soal ini punya bobot lebih tinggi dari yang lain',
          style: cardSubtitle.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<QuestionType>(
          value: controller.selectedQuestionType.value,
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

        _buildAnswerOptionsSection(),
      ],
    );
  }

  Widget _buildAnswerOptionsSection() {
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
