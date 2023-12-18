import 'package:go_router/go_router.dart';
import 'package:project_s4/api/jwt_service.dart';
import 'package:project_s4/model/author.dart';
import 'package:project_s4/model/lesson.dart';
import 'package:project_s4/screens/detail_lesson.dart';
import 'package:project_s4/screens/homepage.dart';
import 'package:project_s4/screens/login_page.dart';
import 'package:project_s4/screens/profile_author.dart';
import 'package:project_s4/screens/quiz_page.dart';
import 'package:project_s4/screens/quiz_result.dart';
import 'package:project_s4/screens/register_page.dart';
import 'package:project_s4/screens/verify_page.dart';

GoRouter router() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => LoginPage(),
        routes: [
          GoRoute(
            path: 'register',
            builder: (context, state) {
              return RegisterPage();
            },
            routes: [
              GoRoute(
                path: 'verify_page',
                builder: (context, state) {
                  return VerifyPage();
                },
              )
            ],
          ),
        ],
        redirect: (context, state) async {
          if (await JWTService().isTokenExpired()) {
            return null;
          } else {
            return '/homepage';
          }
        },
      ),
      GoRoute(
        path: '/homepage',
        name: 'homepage',
        builder: (context, state) => HomePage(),
        routes: [
          GoRoute(
            path: 'profile_author',
            name: 'profile_author',
            builder: (context, state) {
              Author author = state.extra as Author;
              return ProfileAuthor(
                author: author,
              );
            },
          ),
          GoRoute(
            path: 'detail_lesson',
            name: 'detail_lesson',
            builder: (context, state) {
              Lesson lesson = state.extra as Lesson;
              return LessonDetail(
                lesson: lesson,
              );
            },
            routes: [
              GoRoute(
                path: 'quiz_page',
                name: 'quiz_page',
                builder: (context, state) {
                  Lesson lesson = state.extra as Lesson;
                  return QuizPage(
                    questionsLesson: lesson,
                  );
                },
              ),
              GoRoute(
                path: 'quiz_result',
                name: 'quiz_result',
                builder: (context, state) {
                  Lesson lesson = state.extra as Lesson;
                  return QuizResult(
                    testResult: lesson,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
