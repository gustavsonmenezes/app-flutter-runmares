import 'package:flutter/material.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/formatters/metric_formatters.dart';

class RecordingMetrics extends StatelessWidget {
  const RecordingMetrics({
    required this.distanceMeters,
    required this.elapsed,
    required this.paceSecondsPerKilometer,
    this.unit = DistanceUnit.kilometers,
    super.key,
  });

  final double distanceMeters;
  final Duration elapsed;
  final int? paceSecondsPerKilometer;
  final DistanceUnit unit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          MetricFormatters.distance(distanceMeters, unit),
          style: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(unit.label, style: textTheme.titleMedium),
        const SizedBox(height: AppSpacing.screenPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _MetricItem(
              label: 'Tempo',
              value: MetricFormatters.duration(elapsed),
            ),
            _MetricItem(
              label: 'Ritmo (min/${unit.label})',
              value: MetricFormatters.pace(paceSecondsPerKilometer, unit),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          value,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: textTheme.bodyMedium),
      ],
    );
  }
}
