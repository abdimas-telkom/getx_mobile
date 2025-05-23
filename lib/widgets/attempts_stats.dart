import 'package:flutter/material.dart';

import '../models/quiz_attempt.dart';
import 'stat_item.dart';

Widget AttemptsStats(List<QuizAttempt> attempts) {
  final total = attempts.length;
  final completed = attempts
      .where((a) => a.status.toLowerCase() == 'completed')
      .length;
  final scores = attempts
      .where((a) => a.score > 0)
      .map((a) => a.score.toDouble())
      .toList();
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
            'Statistics',
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
              StatItem(label: 'Total Attempts', value: '$total'),
              StatItem(label: 'Completed', value: '$completed'),
              StatItem(
                label: 'Avg. Score',
                value: '${avgScore.toStringAsFixed(1)}%',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
