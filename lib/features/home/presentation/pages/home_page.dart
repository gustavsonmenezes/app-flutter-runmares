import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:runmares/app/router/app_routes.dart';
import 'package:runmares/core/constants/app_spacing.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Resumo da semana e últimas atividades'),
            const SizedBox(height: AppSpacing.itemGap),
            FilledButton(
              onPressed: () => context.push(AppRoutes.recording),
              child: const Text('Iniciar atividade'),
            ),
          ],
        ),
      ),
    );
  }
}
