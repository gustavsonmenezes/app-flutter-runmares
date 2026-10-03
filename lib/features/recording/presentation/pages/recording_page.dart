import 'package:flutter/material.dart';
import 'package:runmares/core/constants/app_spacing.dart';

class RecordingPage extends StatelessWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gravar atividade')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Text(
            'Mapa, distância, tempo e ritmo aparecerão aqui',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
