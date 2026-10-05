import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runmares/app/router/app_routes.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/core/formatters/metric_formatters.dart';
import 'package:runmares/features/auth/presentation/providers/current_user_provider.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/history/presentation/providers/history_providers.dart';
import 'package:runmares/features/history/presentation/widgets/activity_list_tile.dart';
import 'package:runmares/features/recording/data/recording_draft_repository_provider.dart';
import 'package:runmares/features/recording/domain/recording_draft.dart';
import 'package:runmares/features/recording/domain/recording_status.dart';
import 'package:runmares/features/recording/presentation/controllers/recording_controller.dart';
import 'package:runmares/features/recording/presentation/extensions/activity_type_presentation.dart';
import 'package:runmares/features/statistics/domain/period_statistics.dart';
import 'package:runmares/features/statistics/domain/statistics_calculator.dart';
import 'package:runmares/features/statistics/presentation/providers/statistics_clock_provider.dart';
import 'package:runmares/features/statistics/presentation/widgets/statistics_view.dart';
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
    final email = ref.watch(currentUserProvider)?.email;
    final activities = ref.watch(activitySummariesProvider);
    final now = ref.watch(statisticsClockProvider)();
    final textTheme = Theme.of(context).textTheme;
    final name = email?.split('@').first;

    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              name == null || name.isEmpty ? 'Olá!' : 'Olá, $name',
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.itemGap),
            FilledButton(
              onPressed: () => context.push(AppRoutes.recording),
              child: const Text('Iniciar atividade'),
            ),
            const SizedBox(height: AppSpacing.screenPadding),
            ...activities.when<List<Widget>>(
              loading: () => const [Center(child: CircularProgressIndicator())],
              error: (error, stackTrace) => const [
                Text(
                  'Não foi possível carregar as atividades.',
                  textAlign: TextAlign.center,
                ),
              ],
              data: (items) => [
                Text('Esta semana', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.itemGap),
                StatisticsView(
                  statistics: StatisticsCalculator.calculate(
                    activities: items,
                    period: StatisticsPeriod.week,
                    now: now,
                  ),
                ),
                const SizedBox(height: AppSpacing.screenPadding),
                _RecentActivities(items: items),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivities extends StatelessWidget {
  const _RecentActivities({required this.items});

  final List<ActivitySummary> items;

  static const int _visibleCount = 3;

  @override
  Widget build(BuildContext context) {
    final recent = items.take(_visibleCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Últimas atividades',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.itemGap),
        if (recent.isEmpty)
          const Text(
            'Você ainda não registrou nenhuma atividade.',
            textAlign: TextAlign.center,
          )
        else ...[
          for (final summary in recent)
            ActivityListTile(
              summary: summary,
              onTap: () => context.push(
                AppRoutes.activityDetails(summary.id.toString()),
              ),
            ),
          TextButton(
            onPressed: () => context.go(AppRoutes.history),
            child: const Text('Ver histórico'),
          ),
        ],
      ],
    );
  }
}
