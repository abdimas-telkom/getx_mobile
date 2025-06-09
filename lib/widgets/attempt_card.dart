import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/quiz_attempt.dart';

Widget AttemptCard({required QuizAttempt attempt}) {
  Color statusColor;
  switch (attempt.status.toLowerCase()) {
    case 'completed':
      statusColor = Colors.green;
      break;
    case 'in progress':
      statusColor = Colors.orange;
      break;
    default:
      statusColor = Colors.grey;
  }

  String formatDate(String? iso) {
    if (iso == null) return 'N/A';
    try {
      return DateFormat('MMM d, yyyy - h:mm a').format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }

  // --- FIX 1: The ratio for color-coding is now based on the percentage score itself.
  // We divide by 100 to get a value between 0.0 and 1.0.
  final double scoreRatio = attempt.score / 100.0;

  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 2,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              attempt.user?.name ?? 'Unknown Student',
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Display the percentage score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              // The color logic now works correctly with the new ratio
              color: scoreRatio >= 0.7 ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(4),
            ),
            // --- FIX 2: Display the score as a simple percentage. ---
            child: Text(
              '${attempt.score.round()}%', // e.g., "58%"
              style: TextStyle(
                color: scoreRatio >= 0.7 ? Colors.green[800] : Colors.red[800],
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
                  style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Started: ${formatDate(attempt.createdAt)}',
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