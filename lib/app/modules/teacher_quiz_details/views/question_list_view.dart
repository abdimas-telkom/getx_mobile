import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/question_display_card.dart';
import '../controllers/question_list_controller.dart';

class QuestionListView extends GetView<QuestionListController> {
  const QuestionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Detail Pertanyaan',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Obx(
                () => Text(
                  '${controller.questions.length} pertanyaan',
                  style: const TextStyle(color: textGreyColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        Expanded(
          child: Obx(() {
            if (controller.questions.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada soal.\nKetuk tombol + untuk menambah.',
                  textAlign: TextAlign.center,
                  style: cardSubtitle,
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: controller.questions.length,
              itemBuilder: (_, index) {
                final q = controller.questions[index];
                return QuestionDisplayCard(q, index, controller);
              },
            );
          }),
        ),
      ],
    );
  }
}
