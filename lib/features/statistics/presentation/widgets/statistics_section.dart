import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/features/history/presentation/providers/history_providers.dart';
import 'package:runmares/features/settings/presentation/providers/settings_providers.dart';
import 'package:runmares/features/statistics/domain/period_statistics.dart';
import 'package:runmares/features/statistics/domain/statistics_calculator.dart';
import 'package:runmares/features/statistics/presentation/providers/statistics_clock_provider.dart';
import 'package:runmares/features/statistics/presentation/widgets/statistics_view.dart';

class StatisticsSection extends ConsumerStatefulWidget {
  const StatisticsSection({super.key});

  @override
  ConsumerState<StatisticsSection> createState() => _StatisticsSectionState();
}

class _StatisticsSectionState extends ConsumerState<StatisticsSection> {
  StatisticsPeriod _period = StatisticsPeriod.week;

  @override
  Widget build(BuildContext context) {
    final activities = ref.watch(activitySummariesProvider);
    final now = ref.watch(statisticsClockProvider)();
    final unit = ref.watch(distanceUnitProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<StatisticsPeriod>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: StatisticsPeriod.week, label: Text('Semana')),
            ButtonSegment(value: StatisticsPeriod.month, label: Text('Mês')),
          ],
          selected: {_period},
          onSelectionChanged: (selection) {
            setState(() => _period = selection.first);
          },
        ),
        const SizedBox(height: AppSpacing.itemGap),
        activities.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => const Text(
            'Não foi possível carregar as estatísticas.',
            textAlign: TextAlign.center,
          ),
          data: (items) => StatisticsView(
            statistics: StatisticsCalculator.calculate(
              activities: items,
              period: _period,
              now: now,
            ),
            unit: unit,
          ),
        ),
      ],
    );
  }
}
