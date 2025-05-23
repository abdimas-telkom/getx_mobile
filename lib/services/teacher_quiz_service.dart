import 'package:ujian_sd_babakan_ciparay/models/quiz_attempt.dart';

import 'api_client.dart';

class TeacherQuizService {
  static Future<Map<String, dynamic>> createQuiz({
    required String title,
    String? description,
    String? code,
    bool isActive = false,
    int? timeLimit,
  }) async {
    final data = {
      'title': title,
      'is_active': isActive,
      if (description != null) 'description': description,
      if (code != null) 'code': code,
      if (timeLimit != null) 'time_limit': timeLimit,
    };
    final resp = await ApiClient.instance.post('/teacher/quizzes', data: data);
    return resp.data;
  }

  static Future<List<dynamic>> getQuizzes() async {
    final resp = await ApiClient.instance.get('/teacher/quizzes');
    return resp.data;
  }

  static Future<List<QuizAttempt>> getQuizAttempts(int quizId) async {
    final resp = await ApiClient.instance.get(
      '/teacher/quizzes/$quizId/attempts',
    );
    if (resp.data is Map && resp.data.containsKey('data')) {
      return (resp.data['data'] as List)
          .map<QuizAttempt>((item) => QuizAttempt.fromJson(item))
          .toList();
    }

    if (resp.data is List) {
      return resp.data
          .map<QuizAttempt>((item) => QuizAttempt.fromJson(item))
          .toList();
    }

    return [];
  }

  static Future<Map<String, dynamic>> getQuizDetails(int id) async {
    final resp = await ApiClient.instance.get('/teacher/quizzes/$id');
    return resp.data;
  }

  static Future<Map<String, dynamic>> updateQuiz(
    int id,
    Map<String, dynamic> updates,
  ) async {
    final resp = await ApiClient.instance.put(
      '/teacher/quizzes/$id',
      data: updates,
    );
    return resp.data;
  }

  static Future<void> deleteQuiz(int id) async {
    await ApiClient.instance.delete('/teacher/quizzes/$id');
  }

  static Future<Map<String, dynamic>> toggleStatus(int id) async {
    final resp = await ApiClient.instance.post('/teacher/quizzes/$id/status');
    return resp.data;
  }

  static Future<Map<String, dynamic>> addQuestion(
    int quizId,
    String questionText,
    List<Map<String, dynamic>> answers, {
    int points = 1,
  }) async {
    final resp = await ApiClient.instance.post(
      '/teacher/quizzes/$quizId/questions',
      data: {
        'question_text': questionText,
        'points': points,
        'answers': answers,
      },
    );
    return resp.data;
  }

  static Future<Map<String, dynamic>> updateQuestion(
    int quizId,
    int questionId,
    String questionText,
    List<Map<String, dynamic>> answers, {
    int? points,
  }) async {
    final data = {
      'question_text': questionText,
      'answers': answers,
      if (points != null) 'points': points,
    };
    final resp = await ApiClient.instance.put(
      '/teacher/quizzes/$quizId/questions/$questionId',
      data: data,
    );
    return resp.data;
  }

  static Future<void> deleteQuestion(int quizId, int questionId) async {
    await ApiClient.instance.delete(
      '/teacher/quizzes/$quizId/questions/$questionId',
    );
  }

  static Future<Map<String, dynamic>> reorderQuestions(
    int quizId,
    List<int> order,
  ) async {
    final resp = await ApiClient.instance.post(
      '/teacher/quizzes/$quizId/questions/reorder',
      data: {'questions': order},
    );
    return resp.data;
  }
}
