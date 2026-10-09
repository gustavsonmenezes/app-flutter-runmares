import 'package:flutter/material.dart';
import 'package:runmares/app/theme/app_colors.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/formatters/metric_formatters.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/recording/domain/pace_calculator.dart';
import 'package:runmares/features/recording/presentation/extensions/activity_type_presentation.dart';

class ActivityListTile extends StatelessWidget {
  const ActivityListTile({
    required this.summary,
    required this.onTap,
    this.unit = DistanceUnit.kilometers,
    super.key,
  });

  final ActivitySummary summary;
  final VoidCallback onTap;
  final DistanceUnit unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final distance = MetricFormatters.distance(summary.distanceMeters, unit);
    final duration = MetricFormatters.duration(summary.duration);
    final avgPaceSec = PaceCalculator.secondsPerKilometer(
      distanceMeters: summary.distanceMeters,
      elapsed: summary.duration,
    );
    final pace = MetricFormatters.pace(avgPaceSec, unit);

    final title =
        '${summary.type.label} · ${MetricFormatters.dateTime(summary.startedAt)}';
    final subtitleText = '$distance ${unit.label} · $duration';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: AppColors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      summary.type.icon,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          subtitleText,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _SyncBadge(isSynced: summary.isSynced),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MetricPillar(
                    label: 'DISTÂNCIA',
                    value: '$distance ${unit.label}',
                  ),
                  _MetricPillar(
                    label: 'PACE MÉDIO',
                    value: '$pace /${unit.label}',
                  ),
                  _MetricPillar(label: 'TEMPO', value: duration),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricPillar extends StatelessWidget {
  const _MetricPillar({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _SyncBadge extends StatelessWidget {
  const _SyncBadge({required this.isSynced});

  final bool isSynced;

  @override
  Widget build(BuildContext context) {
    final color = isSynced ? AppColors.accentSuccess : AppColors.accentWarning;
    final icon = isSynced
        ? Icons.cloud_done_outlined
        : Icons.cloud_upload_outlined;
    final label = isSynced ? 'Sincronizado' : 'Pendente';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
