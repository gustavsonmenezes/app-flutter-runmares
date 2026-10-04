import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runmares/app/router/app_routes.dart';
import 'package:runmares/app/router/main_shell.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/presentation/auth_form_mode.dart';
import 'package:runmares/features/auth/presentation/pages/auth_form_page.dart';
import 'package:runmares/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:runmares/features/history/presentation/pages/activity_details_page.dart';
import 'package:runmares/features/history/presentation/pages/history_page.dart';
import 'package:runmares/features/home/presentation/pages/home_page.dart';
import 'package:runmares/features/profile/presentation/pages/profile_page.dart';
import 'package:runmares/features/recording/presentation/pages/recording_page.dart';
import 'package:runmares/features/settings/presentation/pages/settings_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final authChanges = ValueNotifier<int>(0);

  // Cada mudança de login reavalia o redirecionamento.
  ref.listen(authStateProvider, (previous, next) => authChanges.value++);

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home,
    refreshListenable: authChanges,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) =>
            const AuthFormPage(mode: AuthFormMode.signIn),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) =>
            const AuthFormPage(mode: AuthFormMode.signUp),
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
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const RecordingPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    authChanges.dispose();
  });

  return router;
});

String? _redirect(Ref ref, GoRouterState state) {
  final isLoggedIn = ref.read(authRepositoryProvider).currentUser != null;
  final location = state.matchedLocation;
  final isAuthRoute =
      location == AppRoutes.login || location == AppRoutes.register;

  if (!isLoggedIn) return isAuthRoute ? null : AppRoutes.login;
  return isAuthRoute ? AppRoutes.home : null;
}
