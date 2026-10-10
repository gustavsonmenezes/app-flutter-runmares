import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:runmares/app/theme/app_colors.dart';
import 'package:runmares/core/constants/app_spacing.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/formatters/metric_formatters.dart';
import 'package:runmares/core/widgets/map_style.dart';
import 'package:runmares/core/widgets/route_map.dart';
import 'package:runmares/features/ai_coach/presentation/widgets/ai_coach_card.dart';
import 'package:runmares/features/history/domain/activity_details.dart';
import 'package:runmares/features/history/presentation/providers/history_providers.dart';
import 'package:runmares/features/history/presentation/widgets/shareable_activity_card.dart';
import 'package:runmares/features/recording/domain/pace_calculator.dart';
import 'package:runmares/features/recording/domain/pace_color_calculator.dart';
import 'package:runmares/features/recording/presentation/extensions/activity_type_presentation.dart';
import 'package:runmares/features/recording/presentation/extensions/route_segments_extension.dart';
import 'package:runmares/features/recording/presentation/widgets/recording_metrics.dart';
import 'package:runmares/features/settings/presentation/providers/settings_providers.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

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

class _DetailsContent extends StatefulWidget {
  const _DetailsContent({
    required this.details,
    required this.unit,
    required this.mapStyle,
  });

  final ActivityDetails details;
  final DistanceUnit unit;
  final MapStyle mapStyle;

  @override
  State<_DetailsContent> createState() => _DetailsContentState();
}

class _DetailsContentState extends State<_DetailsContent> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

  Future<void> _shareCard() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      final imageBytes = await _screenshotController.captureFromWidget(
        Material(
          color: Colors.transparent,
          child: ShareableActivityCard(
            details: widget.details,
            unit: widget.unit,
          ),
        ),
        delay: const Duration(milliseconds: 100),
      );

      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/runmares_activity_${widget.details.summary.id}.png',
      ).create();
      await file.writeAsBytes(imageBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(
              file.path,
              mimeType: 'image/png',
              name: 'runmares_treino.png',
            ),
          ],
          subject: 'Treino no RunMares 🏃',
          text: 'Confira meu treino no RunMares! 🏃🔥',
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível gerar a imagem de compartilhamento.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.details.summary;
    final coloredSegments = PaceColorCalculator.calculateSegments(widget.details.segments);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${summary.type.label} · '
            '${MetricFormatters.dateTime(summary.startedAt)}',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          SizedBox(
            height: 240,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.mapCornerRadius),
              child: RouteMap(
                segments: widget.details.segments.toLatLngSegments(),
                coloredSegments: coloredSegments,
                showPaceLegend: true,
                fitRoute: true,
                style: widget.mapStyle,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          RecordingMetrics(
            distanceMeters: summary.distanceMeters,
            elapsed: summary.duration,
            unit: widget.unit,
            paceSecondsPerKilometer: PaceCalculator.secondsPerKilometer(
              distanceMeters: summary.distanceMeters,
              elapsed: summary.duration,
            ),
          ),
          const SizedBox(height: AppSpacing.screenPadding),
          AiCoachCard(details: widget.details),
          const SizedBox(height: AppSpacing.screenPadding),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _isSharing ? null : _shareCard,
              icon: _isSharing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.share_rounded),
              label: const Text(
                'Compartilhar Treino',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
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
