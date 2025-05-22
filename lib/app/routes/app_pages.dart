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

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

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
  ];
}
