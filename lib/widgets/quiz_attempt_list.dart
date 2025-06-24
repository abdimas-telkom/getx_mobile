// widgets/quiz_attempt_list.dart
import 'package:flutter/material.dart';
import '../models/quiz_attempt.dart';
import 'attempt_card.dart'; // Import the refactored card
import 'attempts_stats.dart'; // Import the refactored stats

class QuizAttemptsList extends StatelessWidget {
  final List<QuizAttempt> attempts;
  final bool isLoading;
  final VoidCallback onRefresh;

  const QuizAttemptsList({
    super.key,
    required this.attempts,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ujian Percobaan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: onRefresh,
                    tooltip: 'Refresh Percobaan',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AttemptsStats(attempts),
              const SizedBox(height: 16),
              if (isLoading && attempts.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (attempts.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'Belum ada percobaan.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attempts.length,
                  itemBuilder: (context, index) {
                    final attempt = attempts[index];
                    return AttemptCard(attempt);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
