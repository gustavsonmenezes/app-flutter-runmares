import 'package:flutter/material.dart';
import 'package:runmares/app/theme/app_colors.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/formatters/metric_formatters.dart';

class RecordingMetrics extends StatelessWidget {
  const RecordingMetrics({
    required this.distanceMeters,
    required this.elapsed,
    required this.paceSecondsPerKilometer,
    this.currentPaceSecondsPerKilometer,
    this.showCurrentPace = false,
    this.unit = DistanceUnit.kilometers,
    super.key,
  });

  final double distanceMeters;
  final Duration elapsed;
  final int? paceSecondsPerKilometer;
  final int? currentPaceSecondsPerKilometer;
  final bool showCurrentPace;
  final DistanceUnit unit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'DISTÂNCIA (${unit.label.toUpperCase()})',
            style: textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            MetricFormatters.distance(distanceMeters, unit),
            style: textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 42,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  label: 'TEMPO',
                  value: MetricFormatters.duration(elapsed),
                ),
              ),
              if (showCurrentPace)
                Expanded(
                  child: _MetricItem(
                    label: 'PACE ATUAL',
                    value: MetricFormatters.pace(
                      currentPaceSecondsPerKilometer,
                      unit,
                    ),
                  ),
                ),
              Expanded(
                child: _MetricItem(
                  label: showCurrentPace ? 'PACE MÉDIO' : 'RITMO MÉDIO',
                  value: MetricFormatters.pace(paceSecondsPerKilometer, unit),
                ),
              ),
            ],
          ),
        ],
      ),
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
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
