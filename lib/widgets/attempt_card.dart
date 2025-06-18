import 'package:flutter/material.dart';
import 'package:ujian_sd_babakan_ciparay/models/quiz_attempt.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

Widget AttemptCard(QuizAttempt attempt) {
  final isFinished = attempt.status == 'finished';
  final score = attempt.score;
  final date = attempt.startTime;

  return Container(
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
            Text(attempt.studentName ?? 'Unknown Student', style: cardTitle),
            Row(
              children: [
                if (isFinished)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: greenColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      score.toStringAsFixed(0),
                      style: const TextStyle(
                        color: greenColor,
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isFinished
                    ? greenColor.withOpacity(0.8)
                    : Colors.orange.withOpacity(0.8),
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
  );
}
