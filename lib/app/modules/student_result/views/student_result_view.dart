import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/models/question_result.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';
import '../controllers/student_result_controller.dart';

class StudentResultView extends GetView<StudentResultController> {
  const StudentResultView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Ujian'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final result = controller.results.value;
        if (result == null) {
          return const Center(child: Text('Gagal memuat hasil ujian.'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildScoreCard(
                result.percentage,
                result.score,
                result.totalPoints,
              ),
              const SizedBox(height: 24),
              const Text('Rincian Jawaban', style: headingSection),
              const SizedBox(height: 8),
              Column(
                children: result.questions
                    .map((q) => _buildReviewCard(q))
                    .toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: controller.backHome,
                child: const Text('Kembali ke Halaman Utama'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildScoreCard(double percentage, double rawScore, int totalPoints) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Nilai Akhir Anda', style: formLabel),
          const SizedBox(height: 8),
          Text(
            percentage.toStringAsFixed(0),
            style: headingDisplay.copyWith(fontSize: 56, color: primaryColor),
          ),
          Text(
            '${rawScore.toStringAsFixed(0)} dari $totalPoints Poin',
            style: cardSubtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(QuestionResult question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: question.isCorrect
            ? greenColor.withValues(alpha: 0.08)
            : redColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                question.isCorrect
                    ? Icons.check_circle_outline
                    : Icons.highlight_off,
                color: question.isCorrect ? greenColor : redColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(question.questionText, style: formLabel)),
            ],
          ),
          const SizedBox(height: 8),
          _buildAnswerDetails(question),
        ],
      ),
    );
  }

  Widget _buildAnswerDetails(QuestionResult question) {
    switch (question.questionType) {
      case 'multiple_choice_multiple':
        return _buildListAnswerReview(
          userAnswers: (question.userAnswer as List?)?.cast<String>() ?? [],
          correctAnswers:
              (question.correctAnswer as List?)?.cast<String>() ?? [],
        );
      case 'matching':
        return _buildMatchingReview(
          userMatching:
              (question.userAnswer as List?)?.cast<Map<String, dynamic>>() ??
              [],
          correctMatching:
              (question.correctAnswer as List?)?.cast<Map<String, dynamic>>() ??
              [],
        );
      case 'weighted_options':
        return _buildWeightedReview(
          question.userAnswer?.toString(),
          question.isCorrect,
        );
      default:
        return _buildSimpleAnswerReview(
          userAnswer: question.userAnswer?.toString(),
          correctAnswer: question.correctAnswer?.toString(),
          isCorrect: question.isCorrect,
        );
    }
  }

  Widget _buildSimpleAnswerReview({
    String? userAnswer,
    String? correctAnswer,
    required bool isCorrect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jawaban Anda: ${userAnswer ?? "—"}',
          style: bodyRegular.copyWith(color: isCorrect ? greenColor : redColor),
        ),
        if (!isCorrect) ...[
          const SizedBox(height: 4),
          Text(
            'Jawaban Benar: ${correctAnswer ?? "N/A"}',
            style: bodyRegular.copyWith(color: greenColor),
          ),
        ],
      ],
    );
  }

  Widget _buildListAnswerReview({
    required List<String> userAnswers,
    required List<String> correctAnswers,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jawaban Anda: ${userAnswers.isEmpty ? "—" : userAnswers.join(', ')}',
          style: bodyRegular.copyWith(
            color: userAnswers.toSet().containsAll(correctAnswers)
                ? greenColor
                : redColor,
          ),
        ),
        const SizedBox(height: 4),
        if (userAnswers.isEmpty ||
            !userAnswers.toSet().containsAll(correctAnswers))
          Text(
            'Jawaban Benar: ${correctAnswers.join(', ')}',
            style: bodyRegular.copyWith(color: greenColor),
          ),
      ],
    );
  }

  Widget _buildMatchingReview({
    required List<Map<String, dynamic>> userMatching,
    required List<Map<String, dynamic>> correctMatching,
  }) {
    final correctMap = {
      for (var item in correctMatching) item['prompt']: item['correct_answer'],
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: userMatching.map((userPair) {
        final prompt = userPair['prompt'];
        final userAnswer = userPair['selected_answer'];
        final correctAnswer = correctMap[prompt];
        final isPairCorrect = userAnswer == correctAnswer;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Untuk: "$prompt"',
                style: cardSubtitle.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '  Jawaban Anda: $userAnswer',
                style: TextStyle(color: isPairCorrect ? greenColor : redColor),
              ),
              if (!isPairCorrect)
                Text(
                  '  Jawaban Benar: $correctAnswer',
                  style: const TextStyle(color: greenColor),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeightedReview(String? userAnswer, bool isCorrect) {
    return Text('Pilihan Anda: ${userAnswer ?? "—"}', style: bodyRegular);
  }
}
