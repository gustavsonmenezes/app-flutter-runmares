import 'package:flutter/material.dart';
import 'package:runmares/core/formatters/metric_formatters.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/recording/presentation/extensions/activity_type_presentation.dart';

class ActivityListTile extends StatelessWidget {
  const ActivityListTile({
    required this.summary,
    required this.onTap,
    super.key,
  });

  final ActivitySummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final distance = MetricFormatters.distanceInKilometers(
      summary.distanceMeters,
    );
    final duration = MetricFormatters.duration(summary.duration);

    return ListTile(
      leading: Icon(summary.type.icon),
      title: Text(
        '${summary.type.label} · '
        '${MetricFormatters.dateTime(summary.startedAt)}',
      ),
      subtitle: Text('$distance km · $duration'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            summary.isSynced
                ? Icons.cloud_done_outlined
                : Icons.cloud_upload_outlined,
            semanticLabel: summary.isSynced
                ? 'Sincronizada'
                : 'Pendente de sincronização',
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }
}
