import 'package:flutter/material.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/features/recording/domain/recording_status.dart';

class RecordingControls extends StatelessWidget {
  const RecordingControls({
    required this.status,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onFinish,
    required this.onNewActivity,
    super.key,
  });

  final RecordingStatus status;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onFinish;
  final VoidCallback onNewActivity;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      RecordingStatus.idle => FilledButton(
        onPressed: onStart,
        child: const Text('Iniciar'),
      ),
      RecordingStatus.recording => _PauseAndFinishButtons(
        secondaryLabel: 'Pausar',
        onSecondary: onPause,
        onFinish: onFinish,
      ),
      RecordingStatus.paused => _PauseAndFinishButtons(
        secondaryLabel: 'Retomar',
        onSecondary: onResume,
        onFinish: onFinish,
      ),
      RecordingStatus.finished => FilledButton(
        onPressed: onNewActivity,
        child: const Text('Nova atividade'),
      ),
    };
  }
}

class _PauseAndFinishButtons extends StatelessWidget {
  const _PauseAndFinishButtons({
    required this.secondaryLabel,
    required this.onSecondary,
    required this.onFinish,
  });

  final String secondaryLabel;
  final VoidCallback onSecondary;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onSecondary,
            child: Text(secondaryLabel),
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: FilledButton(
            onPressed: onFinish,
            child: const Text('Finalizar'),
          ),
        ),
      ],
    );
  }
}
