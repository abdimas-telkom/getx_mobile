import 'package:flutter/material.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

Widget QuizCard({required dynamic quiz, required VoidCallback onTap}) {
  final title = quiz['title'] ?? 'Tanpa Judul';
  final code = quiz['code'] ?? 'N/A';
  final questionCount = quiz['questions_count'] ?? 0;

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
                Text(title, style: cardTitle),
                const SizedBox(height: 4),
                Text('Code: $code', style: cardSubtitle),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right side: Question Count and Icon
          Row(
            children: [
              Text('$questionCount Pertanyaan', style: cardSubtitle),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: textMutedColor, size: 20),
            ],
          ),
        ],
      ),
    ),
  );
}
