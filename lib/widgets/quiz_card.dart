import 'package:flutter/material.dart';
import 'package:ujian_sd_babakan_ciparay/models/quiz.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

Widget QuizCard({required Quiz quiz, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Title and Code
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(quiz.title, style: cardTitle),
                const SizedBox(height: 4),
                Text('Code: ${quiz.code}', style: cardSubtitle),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right side: Question Count and Icon
          Row(
            children: [
              Text('${quiz.questionsCount} Pertanyaan', style: cardSubtitle),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: textMutedColor, size: 20),
            ],
          ),
        ],
      ),
    ),
  );
}
