import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:runmares/app/router/app_routes.dart';
import 'package:runmares/core/constants/app_spacing.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  static const String _sampleActivityId = 'exemplo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Lista das atividades salvas'),
            const SizedBox(height: AppSpacing.itemGap),
            FilledButton(
              onPressed: () =>
                  context.push(AppRoutes.activityDetails(_sampleActivityId)),
              child: const Text('Abrir atividade de exemplo'),
            ),
          ],
        ),
      ),
    );
  }
}
