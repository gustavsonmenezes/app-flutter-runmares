import 'package:flutter/material.dart';
import 'package:runmares/core/constants/app_spacing.dart';

class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage({required this.activityId, super.key});

  final String activityId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da atividade')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Text(
            'Mapa e métricas da atividade "$activityId"',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
