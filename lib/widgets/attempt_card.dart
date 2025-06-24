import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/app/routes/app_pages.dart';
import 'package:ujian_sd_babakan_ciparay/models/quiz_attempt.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

Widget AttemptCard(QuizAttempt attempt) {
  final isFinished = attempt.status == 'finished';
  final score = attempt.score;
  final date = attempt.startTime;

  Color statusColor;
  switch (attempt.status.toLowerCase()) {
    case 'finished':
      statusColor = Colors.green;
      break;
    case 'in progress':
      statusColor = Colors.orange;
      break;
    default:
      statusColor = Colors.grey;
  }

  return GestureDetector(
    onTap: () {
      try {
        Get.offNamed(
          Routes.STUDENT_RESULT,
          arguments: {'attemptId': attempt.id, 'isGuru': true},
        );
      } catch (e) {
        Get.snackbar(
          'Terjadi Kesalahan',
          'Gagal mengirim kuis: ${e.toString()}',
        );
      }
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(attempt.studentName, style: cardTitle),
              Row(
                children: [
                  if (isFinished)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        // The color logic now works correctly with the new ratio
                        color: score >= 70
                            ? Colors.green[100]
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${attempt.score.round()}',
                        style: TextStyle(
                          color: score >= 70
                              ? Colors.green[800]
                              : Colors.red[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isFinished ? 'Selesai' : 'In Progress',
                  style: const TextStyle(color: whiteColor, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text('Dimulai: $date', style: cardSubtitle),
            ],
          ),
        ],
      ),
    ),
  );
}
