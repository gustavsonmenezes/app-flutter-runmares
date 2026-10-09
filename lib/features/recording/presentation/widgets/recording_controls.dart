import 'package:flutter/material.dart';
import 'package:runmares/app/theme/app_colors.dart';
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
      RecordingStatus.idle => SizedBox(
        height: 52,
        child: FilledButton.icon(
          onPressed: onStart,
          icon: const Icon(Icons.play_arrow_rounded, size: 28),
          label: const Text(
            'Iniciar',
            style: TextStyle(fontSize: 18, letterSpacing: 0.5),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ),
      RecordingStatus.recording => _PauseAndFinishButtons(
        secondaryLabel: 'Pausar',
        secondaryIcon: Icons.pause_rounded,
        onSecondary: onPause,
        onFinish: onFinish,
      ),
      RecordingStatus.paused => _PauseAndFinishButtons(
        secondaryLabel: 'Retomar',
        secondaryIcon: Icons.play_arrow_rounded,
        onSecondary: onResume,
        onFinish: onFinish,
      ),
      RecordingStatus.finished => SizedBox(
        height: 52,
        child: FilledButton.icon(
          onPressed: onNewActivity,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Nova atividade'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ),
    };
  }
}

class _PauseAndFinishButtons extends StatelessWidget {
  const _PauseAndFinishButtons({
    required this.secondaryLabel,
    required this.secondaryIcon,
    required this.onSecondary,
    required this.onFinish,
  });

  final String secondaryLabel;
  final IconData secondaryIcon;
  final VoidCallback onSecondary;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              onPressed: onSecondary,
              icon: Icon(secondaryIcon),
              label: Text(secondaryLabel),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: onFinish,
              icon: const Icon(Icons.stop_rounded),
              label: const Text('Finalizar'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
