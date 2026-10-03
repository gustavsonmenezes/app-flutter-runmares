import 'package:flutter/material.dart';
import 'package:runmares/app/router/app_router.dart';
import 'package:runmares/app/theme/app_theme.dart';

class RunMaresApp extends StatelessWidget {
  const RunMaresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RunMares',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.config,
    );
  }
}
