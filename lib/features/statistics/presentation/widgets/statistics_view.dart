import 'package:flutter/material.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/formatters/metric_formatters.dart';
import 'package:runmares/features/statistics/domain/period_statistics.dart';
import 'package:runmares/features/statistics/presentation/widgets/distance_bar_chart.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({
    required this.statistics,
    this.unit = DistanceUnit.kilometers,
    super.key,
  });

  final PeriodStatistics statistics;
  final DistanceUnit unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                value: MetricFormatters.distance(
                  statistics.totalDistanceMeters,
                  unit,
                ),
                label: 'Distância (${unit.label})',
              ),
            ),
            Expanded(
              child: _MetricTile(
                value: MetricFormatters.duration(statistics.totalDuration),
                label: 'Tempo',
              ),
            ),
            Expanded(
              child: _MetricTile(
                value: statistics.activityCount.toString(),
                label: 'Atividades',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.screenPadding),
        if (statistics.isEmpty)
          const Text(
            'Nenhuma atividade neste período.',
            textAlign: TextAlign.center,
          )
        else
          DistanceBarChart(
            buckets: statistics.buckets,
            largestBucketMeters: statistics.largestBucketMeters,
            unit: unit,
          ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          value,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: textTheme.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }
}
