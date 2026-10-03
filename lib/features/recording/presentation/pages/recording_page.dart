import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/features/recording/domain/recording_status.dart';
import 'package:runmares/features/recording/presentation/controllers/recording_controller.dart';
import 'package:runmares/features/recording/presentation/widgets/activity_type_selector.dart';
import 'package:runmares/features/recording/presentation/widgets/recording_controls.dart';

class RecordingPage extends ConsumerWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordingControllerProvider);
    final controller = ref.read(recordingControllerProvider.notifier);
    final isIdle = state.status == RecordingStatus.idle;

    return Scaffold(
      appBar: AppBar(title: const Text('Gravar atividade')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ActivityTypeSelector(
              selected: state.activityType,
              onChanged: isIdle ? controller.selectActivityType : null,
            ),
            const Spacer(),
            Text(
              _statusMessage(state.status),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            RecordingControls(
              status: state.status,
              onStart: controller.start,
              onPause: controller.pause,
              onResume: controller.resume,
              onFinish: () => _confirmFinish(context, controller),
              onNewActivity: controller.reset,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmFinish(
    BuildContext context,
    RecordingController controller,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Finalizar atividade?'),
        content: const Text('Você não poderá retomar esta atividade depois.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );

    if (confirmed == true) controller.finish();
  }

  String _statusMessage(RecordingStatus status) {
    return switch (status) {
      RecordingStatus.idle => 'Escolha o tipo e toque em Iniciar',
      RecordingStatus.recording => 'Gravando...',
      RecordingStatus.paused => 'Atividade pausada',
      RecordingStatus.finished => 'Atividade finalizada',
    };
  }
}
