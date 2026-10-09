import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/app/router/app_router.dart';
import 'package:runmares/app/theme/app_theme.dart';
import 'package:runmares/features/sync/presentation/providers/sync_providers.dart';

class RunMaresApp extends ConsumerWidget {
  const RunMaresApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(autoSyncProvider);

    return MaterialApp.router(
      title: 'RunMares',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
