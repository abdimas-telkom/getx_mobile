// File: widgets/quiz_attempt_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/quiz_attempt.dart'; // Make sure this import path is correct

class QuizAttemptsList extends StatelessWidget {
  final List<QuizAttempt> attempts; // Change from List<dynamic> to List<QuizAttempt>
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quiz Attempts',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: onRefresh,
              tooltip: 'Refresh Attempts',
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildAttemptsStats(),
        const SizedBox(height: 16),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (attempts.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'No attempts yet.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          _buildAttemptsList(),
      ],
    );
  }

  Widget _buildAttemptsStats() {
    if (attempts.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate statistics
    int totalAttempts = attempts.length;
    int completedAttempts = attempts.where((a) => a.status == 'completed').length;
    
    // Calculate average score
    double totalScore = 0;
    int scoredAttempts = 0;
    
    for (var attempt in attempts) {
      if (attempt.score > 0) {
        totalScore += attempt.score.toDouble();
        scoredAttempts++;
      }
    }
    
    double averageScore = scoredAttempts > 0 ? totalScore / scoredAttempts : 0;
    
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
                _buildStatItem('Total Attempts', '$totalAttempts'),
                _buildStatItem('Completed', '$completedAttempts'),
                _buildStatItem('Avg. Score', '${averageScore.toStringAsFixed(1)}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAttemptsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attempts.length,
      itemBuilder: (context, index) {
        final attempt = attempts[index];
        return _AttemptCard(attempt: attempt);
      },
    );
  }
}

class _AttemptCard extends StatelessWidget {
  final QuizAttempt attempt; // Changed from Map<String, dynamic> to QuizAttempt

  const _AttemptCard({required this.attempt});

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy - h:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'abandoned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String status = attempt.status;
    final String studentName = attempt.studentName;
    final String startedAt = _formatDate(attempt.startedAt);
    final String? completedAt = attempt.completedAt != null 
        ? _formatDate(attempt.completedAt!) 
        : null;
    final int score = attempt.score;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                studentName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: score >= 70 ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$score%',
                style: TextStyle(
                  color: score >= 70 ? Colors.green[800] : Colors.red[800],
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
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStatusColor(status),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Started: $startedAt',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            if (completedAt != null) ...[
              const SizedBox(height: 2),
              Text(
                'Completed: $completedAt',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}