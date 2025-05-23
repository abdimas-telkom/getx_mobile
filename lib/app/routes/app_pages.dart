import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/student_dashboard/bindings/student_dashboard_binding.dart';
import '../modules/student_dashboard/views/student_dashboard_view.dart';
import '../modules/student_quiz/bindings/student_quiz_binding.dart';
import '../modules/student_quiz/views/student_quiz_view.dart';
import '../modules/student_result/bindings/student_result_binding.dart';
import '../modules/student_result/views/student_result_view.dart';
import '../modules/teacher_add_questions/bindings/teacher_add_questions_binding.dart';
import '../modules/teacher_add_questions/views/teacher_add_questions_view.dart';
import '../modules/teacher_dashboard/bindings/teacher_dashboard_binding.dart';
import '../modules/teacher_dashboard/views/teacher_dashboard_view.dart';
import '../modules/teacher_quiz_create/bindings/teacher_quiz_create_binding.dart';
import '../modules/teacher_quiz_create/views/teacher_quiz_create_view.dart';
import '../modules/teacher_quiz_details/bindings/teacher_quiz_details_binding.dart';
import '../modules/teacher_quiz_details/views/teacher_quiz_details_view.dart';
import '../modules/teacher_quiz_edit/bindings/teacher_quiz_edit_binding.dart';
import '../modules/teacher_quiz_edit/views/teacher_quiz_edit_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.STUDENT_DASHBOARD,
      page: () => const StudentDashboardView(),
      binding: StudentDashboardBinding(),
    ),
    GetPage(
      name: _Paths.STUDENT_QUIZ,
      page: () => const StudentQuizView(),
      binding: StudentQuizBinding(),
    ),
    GetPage(
      name: _Paths.STUDENT_RESULT,
      page: () => const StudentResultView(),
      binding: StudentResultBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.TEACHER_DASHBOARD,
      page: () => const TeacherDashboardView(),
      binding: TeacherDashboardBinding(),
    ),
    GetPage(
      name: _Paths.TEACHER_QUIZ_DETAILS,
      page: () => const TeacherQuizDetailsView(),
      binding: TeacherQuizDetailsBinding(),
    ),
    GetPage(
      name: _Paths.TEACHER_QUIZ_EDIT,
      page: () => const TeacherQuizEditView(),
      binding: TeacherQuizEditBinding(),
    ),
    GetPage(
      name: _Paths.TEACHER_QUIZ_CREATE,
      page: () => const TeacherQuizCreateView(),
      binding: TeacherQuizCreateBinding(),
    ),
    GetPage(
      name: _Paths.TEACHER_ADD_QUESTIONS,
      page: () => const TeacherAddQuestionsView(),
      binding: TeacherAddQuestionsBinding(),
    ),
  ];
}
