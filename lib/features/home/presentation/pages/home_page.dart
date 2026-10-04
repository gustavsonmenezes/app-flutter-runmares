import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runmares/app/router/app_routes.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/core/formatters/metric_formatters.dart';
import 'package:runmares/features/auth/presentation/providers/current_user_provider.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/recording/data/recording_draft_repository_provider.dart';
import 'package:runmares/features/recording/domain/recording_draft.dart';
import 'package:runmares/features/recording/domain/recording_status.dart';
import 'package:runmares/features/recording/presentation/controllers/recording_controller.dart';
import 'package:runmares/features/recording/presentation/extensions/activity_type_presentation.dart';
import 'package:runmares/features/sync/presentation/providers/sync_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _offerRecovery());
  }

  bool get _isRecordingIdle =>
      ref.read(recordingControllerProvider).status == RecordingStatus.idle;

  Future<void> _offerRecovery() async {
    final user = ref.read(currentUserProvider);
    if (!mounted || user == null || !_isRecordingIdle) return;

    final drafts = ref.read(recordingDraftRepositoryProvider);
    final activities = ref.read(activityRepositoryProvider);
    final sync = ref.read(activitySyncServiceProvider);
    final messenger = ScaffoldMessenger.of(context);

    final draft = await drafts.find(user.uid);
    if (draft == null || !mounted || !_isRecordingIdle) return;

    if (!draft.hasPoints) {
      await drafts.discard(user.uid);
      return;
    }

    final shouldSave = await _askToSave(draft);
    if (shouldSave != true) {
      await drafts.discard(user.uid);
      return;
    }

    try {
      await activities.save(draft.toRecordedActivity());
      await drafts.discard(user.uid);
      unawaited(sync.syncPending(user.uid));
      messenger.showSnackBar(
        const SnackBar(content: Text('Atividade recuperada e salva.')),
      );
    } on Exception {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar a atividade interrompida.'),
        ),
      );
    }
  }

  Future<bool?> _askToSave(RecordingDraft draft) {
    final distance = MetricFormatters.distanceInKilometers(
      draft.distanceMeters,
    );

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Atividade interrompida'),
        content: Text(
          '${draft.type.label} de ${MetricFormatters.dateTime(draft.startedAt)}'
          ' · $distance km\n\n'
          'Ela não foi finalizada. Deseja salvar o que foi registrado?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Descartar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

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
