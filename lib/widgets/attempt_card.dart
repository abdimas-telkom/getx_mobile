import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/quiz_attempt.dart';

Widget AttemptCard({required QuizAttempt attempt}) {
  Color statusColor;
  switch (attempt.status.toLowerCase()) {
    case 'completed':
      statusColor = Colors.green;
      break;
    case 'in_progress':
      statusColor = Colors.orange;
      break;
    case 'abandoned':
      statusColor = Colors.red;
      break;
    default:
      statusColor = Colors.grey;
  }

  String formatDate(String iso) {
    try {
      return DateFormat('MMM d, yyyy - h:mm a').format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }

  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              attempt.studentName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: attempt.score >= 70 ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${attempt.score}%',
              style: TextStyle(
                color: attempt.score >= 70
                    ? Colors.green[800]
                    : Colors.red[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  attempt.status.toUpperCase(),
                  style: TextStyle(fontSize: 12, color: statusColor),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Started: ${formatDate(attempt.startedAt)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
          if (attempt.completedAt != null) ...[
            const SizedBox(height: 2),
            Text(
              'Completed: ${formatDate(attempt.completedAt!)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    ),
  );
}
