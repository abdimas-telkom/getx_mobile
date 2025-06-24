// widgets/attempts_stats.dart
import 'package:flutter/material.dart';
import '../models/quiz_attempt.dart';
import 'stat_item.dart'; // Assuming you have this StatItem widget

Widget AttemptsStats(List<QuizAttempt> attempts) {
  if (attempts.isEmpty) return const SizedBox.shrink();

  final total = attempts.length;
  // Use the new model property to find completed attempts
  final completed = attempts.where((a) => a.completedAt != null).length;

  // Calculate the average of the raw score (points)
  final scores = attempts.map((a) => a.score).toList();
  final avgScore = scores.isNotEmpty
      ? scores.reduce((a, b) => a + b) / scores.length
      : 0.0;

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik Ujian',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatItem(label: 'Total Percobaan', value: '$total'),
              StatItem(label: 'Selesai', value: '$completed'),
              StatItem(
                label: 'Rata-rata Skor',
                value: '${avgScore.toStringAsFixed(1)} pts',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
