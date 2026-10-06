import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/formatters/metric_formatters.dart';
import 'package:runmares/core/widgets/map_style.dart';
import 'package:runmares/core/widgets/route_map.dart';
import 'package:runmares/features/history/domain/activity_details.dart';
import 'package:runmares/features/history/presentation/providers/history_providers.dart';
import 'package:runmares/features/recording/domain/pace_calculator.dart';
import 'package:runmares/features/recording/presentation/extensions/activity_type_presentation.dart';
import 'package:runmares/features/recording/presentation/extensions/route_segments_extension.dart';
import 'package:runmares/features/recording/presentation/widgets/recording_metrics.dart';
import 'package:runmares/features/settings/presentation/providers/settings_providers.dart';

class ActivityDetailsPage extends ConsumerWidget {
  const ActivityDetailsPage({required this.activityId, super.key});

  final String activityId;

  static const String _notFoundMessage = 'Atividade não encontrada.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(activityId);
    final unit = ref.watch(distanceUnitProvider);
    final mapStyle = ref.watch(mapStyleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da atividade')),
      body: id == null
          ? const _CenteredMessage(_notFoundMessage)
          : ref
                .watch(activityDetailsProvider(id))
                .when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => const _CenteredMessage(
                    'Não foi possível carregar a atividade.',
                  ),
                  data: (details) => details == null
                      ? const _CenteredMessage(_notFoundMessage)
                      : _DetailsContent(
                          details: details,
                          unit: unit,
                          mapStyle: mapStyle,
                        ),
                ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  const _DetailsContent({
    required this.details,
    required this.unit,
    required this.mapStyle,
  });

  final ActivityDetails details;
  final DistanceUnit unit;
  final MapStyle mapStyle;

  @override
  Widget build(BuildContext context) {
    final summary = details.summary;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${summary.type.label} · '
            '${MetricFormatters.dateTime(summary.startedAt)}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.mapCornerRadius),
              child: RouteMap(
                segments: details.segments.toLatLngSegments(),
                fitRoute: true,
                style: mapStyle,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          RecordingMetrics(
            distanceMeters: summary.distanceMeters,
            elapsed: summary.duration,
            unit: unit,
            paceSecondsPerKilometer: PaceCalculator.secondsPerKilometer(
              distanceMeters: summary.distanceMeters,
              elapsed: summary.duration,
            ),
          ),
        ],
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
