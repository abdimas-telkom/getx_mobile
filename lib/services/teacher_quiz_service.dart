import 'package:dio/dio.dart';
import 'package:ujian_sd_babakan_ciparay/models/quiz.dart';
import 'package:ujian_sd_babakan_ciparay/models/quiz_attempt.dart';
import 'dart:typed_data';

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

  static Future<List<Quiz>> getQuizzes() async {
    final resp = await ApiClient.instance.get('/teacher/quizzes');
    return (resp.data as List).map((json) => Quiz.fromJson(json)).toList();
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

  static Future<Quiz> getQuizDetails(int id) async {
    final resp = await ApiClient.instance.get('/teacher/quizzes/$id');
    return Quiz.fromJson(resp.data);
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
    Map<String, dynamic> questionData,
  ) async {
    final resp = await ApiClient.instance.post(
      '/teacher/quizzes/$quizId/questions',
      data: questionData,
    );
    return resp.data;
  }

  static Future<Map<String, dynamic>> updateQuestion(
    int quizId,
    int questionId,
    Map<String, dynamic> questionData,
  ) async {
    final resp = await ApiClient.instance.put(
      '/teacher/quizzes/$quizId/questions/$questionId',
      data: questionData,
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

  static Future<Map<String, dynamic>> getResults(int attemptId) async {
    final resp = await ApiClient.instance.get('/teacher/attempts/$attemptId');
    return resp.data;
  }

  static Future<Uint8List> exportAttemptsToPdf(int quizId) async {
    final response = await ApiClient.instance.get(
      '/teacher/quizzes/$quizId/export-attempts-pdf',
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data;
  }
}
