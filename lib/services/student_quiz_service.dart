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

  static Future<List<dynamic>> getQuestions(int quizId) async {
    final resp = await ApiClient.instance.get('/quizzes/$quizId/questions');
    return resp.data;
  }

  static Future<Map<String, dynamic>> submitAnswers(
    int quizId,
    List<Map<String, dynamic>> answers,
  ) async {
    final resp = await ApiClient.instance.post(
      '/quizzes/$quizId/submit',
      data: {'answers': answers},
    );
    return resp.data;
  }

  static Future<Map<String, dynamic>> getResults(int attemptId) async {
    final resp = await ApiClient.instance.get('/attempts/$attemptId');
    return resp.data;
  }

  static Future<List<dynamic>> getStudentAttempts() async {
    final resp = await ApiClient.instance.get('/student/attempts');
    final data = resp.data;
    if (data is Map && data.containsKey('attempts')) return data['attempts'];
    return data is List ? data : [];
  }
}
