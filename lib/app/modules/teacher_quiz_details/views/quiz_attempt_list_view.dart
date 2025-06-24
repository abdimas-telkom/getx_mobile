import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/attempt_card.dart';
import '../controllers/teacher_quiz_details_controller.dart';

class QuizAttemptListView extends GetView<TeacherQuizDetailsController> {
  const QuizAttemptListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAttempts.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: controller.loadAttempts,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Hasil Percobaan', style: headingDisplay),
                  Row(
                    children: [
                      Obx(
                        () => (controller.totalAttempts > 0)
                            ? (controller.isExporting.value
                                  ? const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: controller.exportAttempts,
                                      icon: const Icon(
                                        Icons.picture_as_pdf_outlined,
                                      ),
                                      tooltip: 'Export to PDF',
                                    ))
                            : const SizedBox.shrink(),
                      ),
                      IconButton(
                        onPressed: controller.loadAttempts,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh List',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (controller.attempts.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('Belum ada Percobaan', style: cardSubtitle),
                ),
              )
            else
              Expanded(
                child: ListView(
                  children: [
                    _buildStatsCard(),
                    const SizedBox(height: 16),
                    ...controller.attempts.map(
                      (attempt) => AttemptCard(attempt),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('Total Percobaan', controller.totalAttempts.toString()),
          _statItem('Selesai', controller.completedAttempts.toString()),
          _statItem('Rata - Rata', controller.averageScore.toStringAsFixed(1)),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: headingDisplay),
        Text(label, style: cardSubtitle),
      ],
    );
  }
}
