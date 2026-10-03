import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:runmares/app/router/app_routes.dart';
import 'package:runmares/app/router/main_shell.dart';
import 'package:runmares/features/auth/presentation/pages/login_page.dart';
import 'package:runmares/features/history/presentation/pages/activity_details_page.dart';
import 'package:runmares/features/history/presentation/pages/history_page.dart';
import 'package:runmares/features/home/presentation/pages/home_page.dart';
import 'package:runmares/features/profile/presentation/pages/profile_page.dart';
import 'package:runmares/features/recording/presentation/pages/recording_page.dart';
import 'package:runmares/features/settings/presentation/pages/settings_page.dart';

abstract final class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter config = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) => const HistoryPage(),
                routes: [
                  GoRoute(
                    path: ':${AppRoutes.activityIdParam}',
                    builder: (context, state) => ActivityDetailsPage(
                      activityId:
                          state.pathParameters[AppRoutes.activityIdParam]!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.recording,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RecordingPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
