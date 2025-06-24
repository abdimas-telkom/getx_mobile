import 'package:ujian_sd_babakan_ciparay/models/question.dart';
import 'package:ujian_sd_babakan_ciparay/models/quiz_result.dart';
import 'api_client.dart';

class StudentQuizService {
  static Future<List<dynamic>> getActiveQuizzes() async {
    final resp = await ApiClient.instance.get('/student/quizzes');
    return resp.data;
  }

  static Future<Map<String, dynamic>> getQuizByCode(String code) async {
    final resp = await ApiClient.instance.post(
      '/student/quizzes/code',
      data: {'code': code},
    );
    return resp.data;
  }

  static Future<List<Question>> getQuestions(int quizId) async {
    final resp = await ApiClient.instance.get(
      '/student/quizzes/$quizId/questions',
    );
    return (resp.data as List).map((json) => Question.fromJson(json)).toList();
  }

  static Future<Map<String, dynamic>> submitAnswers(
    int quizId,
    List<Map<String, dynamic>> answers,
  ) async {
    final resp = await ApiClient.instance.post(
      '/student/quizzes/$quizId/submit',
      data: {'answers': answers},
    );
    return resp.data;
  }

  static Future<QuizResult> getResults(int attemptId) async {
    final resp = await ApiClient.instance.get('/student/attempts/$attemptId');
    return QuizResult.fromJson(resp.data);
  }

  static Future<List<dynamic>> getStudentAttempts() async {
    final resp = await ApiClient.instance.get('/student/attempts');
    final data = resp.data;
    if (data is Map && data.containsKey('attempts')) return data['attempts'];
    return data is List ? data : [];
  }
}
