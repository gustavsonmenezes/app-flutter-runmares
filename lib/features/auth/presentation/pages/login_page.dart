import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:runmares/app/router/app_routes.dart';
import 'package:runmares/core/constants/app_spacing.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'RunMares',
                style: textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              const Text('Registre cada passo, mesmo sem internet'),
              const SizedBox(height: AppSpacing.screenPadding),
              FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
