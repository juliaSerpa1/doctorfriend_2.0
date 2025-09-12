import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/screens/auth/login_screen.dart';
import 'package:doctorfriend/screens/education/course_select_specialization_screen.dart';
import 'package:doctorfriend/screens/user/user_verification_screen.dart';
import 'package:doctorfriend/screens/auth/auth_type_screen.dart';
import 'package:doctorfriend/screens/auth/signup_screen.dart';
import 'package:doctorfriend/screens/education/course_screen.dart';
import 'package:doctorfriend/screens/education/my_counses_screen.dart';
import 'package:doctorfriend/screens/home_screen.dart';
import 'package:doctorfriend/screens/premium/premium_screen.dart';
import 'package:doctorfriend/screens/schedule/schedule_edit_days.dart';
import 'package:doctorfriend/screens/schedule/schedule_settings_screen.dart';
import 'package:doctorfriend/screens/settings/sticky_notes_screen.dart';
import 'package:doctorfriend/screens/unauthorized_screen.dart';
import 'package:doctorfriend/screens/user/delete_account_screen.dart';
import 'package:doctorfriend/screens/user/evaluations_screen.dart';
import 'package:doctorfriend/screens/user/update_user_screen.dart';
import 'package:doctorfriend/screens/user/user_screen.dart';
import 'package:doctorfriend/screens/webview/web_view_stack.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static GoRouter appRouter({
    required String? currentRoute,
    required Function(String) updateCurrentRoute,
    required Function(ThemeData) updateTheme,
    required AppUser? user,
    required Function(Locale) setLocale,
  }) {
    if (user == null) {
      return loadingRouter();
    }

    return GoRouter(
      initialLocation: currentRoute,
      errorBuilder: (context, state) =>
          AuthTypeScreen(setLocale: setLocale), // <- página padrão
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutesUtil.appType,
          builder: (BuildContext context, GoRouterState state) {
            // return const CourseSelectprofessionScreen();
            // return const HomeScreen();
            return AuthTypeScreen(setLocale: setLocale);
          },
          routes: <RouteBase>[
            GoRoute(
              path: _removeBar(AppRoutesUtil.home),
              builder: (BuildContext context, GoRouterState state) {
                return const HomeScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.login),
              builder: (BuildContext context, GoRouterState state) {
                return const HomeScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.webview),
              builder: (BuildContext context, GoRouterState state) {
                return const WebViewStack();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.platformDF),
              builder: (BuildContext context, GoRouterState state) {
                return const WebViewStack(
                  isSite: false,
                );
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.scheduleSettings),
              builder: (BuildContext context, GoRouterState state) {
                return const ScheduleSettingsScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.evaluations),
              builder: (BuildContext context, GoRouterState state) {
                Map<String, dynamic>? args =
                    state.extra as Map<String, dynamic>?;
                final String? evaluationId = args?['evaluationId'];
                return EvaluationsScreen(
                  id: evaluationId,
                );
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.course),
              builder: (BuildContext context, GoRouterState state) {
                Map<String, dynamic>? args =
                    state.extra as Map<String, dynamic>?;
                final String? evaluationId = args?['courseId'];
                return CourseScreen(
                  id: evaluationId,
                );
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.scheduleEditDays),
              builder: (BuildContext context, GoRouterState state) {
                return const ScheduleEditDays();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.updateUser),
              builder: (BuildContext context, GoRouterState state) {
                return const UpdateUserScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.userVerification),
              builder: (BuildContext context, GoRouterState state) {
                return const UserVerificationScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.deleteAccount),
              builder: (BuildContext context, GoRouterState state) {
                return const DeleteAccountScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.premium),
              builder: (BuildContext context, GoRouterState state) {
                return const PremiumScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.stickyNotes),
              builder: (BuildContext context, GoRouterState state) {
                return const StickyNotesScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.myCourses),
              builder: (BuildContext context, GoRouterState state) {
                return const MyCoursesScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.courseSelectprofession),
              builder: (BuildContext context, GoRouterState state) {
                return const CourseSelectProfessionScreen();
              },
            ),
          ],
        ),
      ],
    );
  }

  static GoRouter getPremiumRouter(
    String? currentRoute,
    Function(String) updateCurrentRoute,
    Function(Locale) setLocale,
  ) {
    return GoRouter(
      initialLocation: currentRoute,
      errorBuilder: (context, state) =>
          AuthTypeScreen(setLocale: setLocale), // <- página padrão
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutesUtil.appType,
          builder: (BuildContext context, GoRouterState state) {
            return AuthTypeScreen(setLocale: setLocale);
          },
          routes: <RouteBase>[
            GoRoute(
              path: _removeBar(AppRoutesUtil.login),
              builder: (BuildContext context, GoRouterState state) {
                updateCurrentRoute(AppRoutesUtil.login);
                return const PremiumScreen(logout: true);
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.webview),
              builder: (BuildContext context, GoRouterState state) {
                return const WebViewStack();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.platformDF),
              builder: (BuildContext context, GoRouterState state) {
                return const WebViewStack(
                  isSite: false,
                );
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.user),
              builder: (BuildContext context, GoRouterState state) {
                return const UserScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.userVerification),
              builder: (BuildContext context, GoRouterState state) {
                return const UserVerificationScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.evaluations),
              builder: (BuildContext context, GoRouterState state) {
                Map<String, dynamic>? args =
                    state.extra as Map<String, dynamic>?;
                final String? evaluationId = args?['evaluationId'];
                return EvaluationsScreen(
                  id: evaluationId,
                );
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.updateUser),
              builder: (BuildContext context, GoRouterState state) {
                return const UpdateUserScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.deleteAccount),
              builder: (BuildContext context, GoRouterState state) {
                return const DeleteAccountScreen();
              },
            ),
          ],
        ),
      ],
    );
  }

  static GoRouter authRouter(
    String? currentRoute,
    Function(String) updateCurrentRoute,
    Function(Locale) setLocale,
  ) {
    return GoRouter(
      initialLocation: currentRoute,
      errorBuilder: (context, state) => const LoginScreen(), // <- página padrão
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutesUtil.appType,
          builder: (BuildContext context, GoRouterState state) {
            // return const SignupScreen();
            return AuthTypeScreen(setLocale: setLocale);
          },
          routes: <RouteBase>[
            GoRoute(
              path: _removeBar(AppRoutesUtil.login),
              builder: (BuildContext context, GoRouterState state) {
                updateCurrentRoute(AppRoutesUtil.login);
                return const LoginScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.webview),
              builder: (BuildContext context, GoRouterState state) {
                return const WebViewStack();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.platformDF),
              builder: (BuildContext context, GoRouterState state) {
                return const WebViewStack(
                  isSite: false,
                );
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.signup),
              builder: (BuildContext context, GoRouterState state) {
                Map<String, dynamic>? args =
                    state.extra as Map<String, dynamic>?;
                final bool updateUser = args?['updateUser'] ?? false;
                return SignupScreen(updateUser: updateUser);
              },
            ),
          ],
        ),
      ],
    );
  }

  static GoRouter unauthorizedRouter(
    String? currentRoute,
    Function(Locale) setLocale,
  ) {
    return GoRouter(
      initialLocation: currentRoute,
      errorBuilder: (context, state) =>
          AuthTypeScreen(setLocale: setLocale), // <- página padrão
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutesUtil.appType,
          builder: (BuildContext context, GoRouterState state) {
            return AuthTypeScreen(setLocale: setLocale);
          },
          routes: <RouteBase>[
            GoRoute(
              path: _removeBar(AppRoutesUtil.login),
              builder: (BuildContext context, GoRouterState state) {
                return const UnauthorizedScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.webview),
              builder: (BuildContext context, GoRouterState state) {
                return const WebViewStack();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.platformDF),
              builder: (BuildContext context, GoRouterState state) {
                return const WebViewStack(
                  isSite: false,
                );
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.user),
              builder: (BuildContext context, GoRouterState state) {
                return const UserScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.evaluations),
              builder: (BuildContext context, GoRouterState state) {
                Map<String, dynamic>? args =
                    state.extra as Map<String, dynamic>?;
                final String? evaluationId = args?['evaluationId'];
                return EvaluationsScreen(
                  id: evaluationId,
                );
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.updateUser),
              builder: (BuildContext context, GoRouterState state) {
                return const UpdateUserScreen();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.deleteAccount),
              builder: (BuildContext context, GoRouterState state) {
                return const DeleteAccountScreen();
              },
            ),
          ],
        ),
      ],
    );
  }

  static GoRouter loadingRouter() {
    return GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: "/",
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(
              body: LoadingIndicator(
                loading: true,
                child: SizedBox(),
              ),
            );
          },
        ),
      ],
    );
  }

  static GoRouter errorRouter(
    Object error,
    String? currentRoute,
    Function(Locale) setLocale,
  ) {
    return GoRouter(
      initialLocation: currentRoute,
      errorBuilder: (context, state) =>
          AuthTypeScreen(setLocale: setLocale), // <- página padrão
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutesUtil.appType,
          builder: (BuildContext context, GoRouterState state) {
            return AuthTypeScreen(setLocale: setLocale);
          },
          routes: [
            GoRoute(
              path: _removeBar(AppRoutesUtil.login),
              builder: (BuildContext context, GoRouterState state) {
                return Scaffold(
                  appBar: AppBar(),
                  body: LoadingIndicator(
                    loading: false,
                    child: Center(
                      child: Text(
                        error.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.webview),
              builder: (BuildContext context, GoRouterState state) {
                return const WebViewStack();
              },
            ),
            GoRoute(
              path: _removeBar(AppRoutesUtil.platformDF),
              builder: (BuildContext context, GoRouterState state) {
                return const WebViewStack(
                  isSite: false,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  static String _removeBar(String route) {
    return route.replaceFirst("/", "");
  }
}
