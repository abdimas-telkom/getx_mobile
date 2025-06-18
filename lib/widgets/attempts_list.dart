import 'package:flutter/material.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/attempt_card.dart';

import '../models/quiz_attempt.dart';

Widget AttemptsList(List<QuizAttempt> attempts) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: attempts.length,
    itemBuilder: (context, i) => AttemptCard(attempts[i]),
  );
}
