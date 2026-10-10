import 'package:flutter/material.dart';
import 'package:runmares/app/theme/app_colors.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/formatters/metric_formatters.dart';
import 'package:runmares/core/widgets/map_style.dart';
import 'package:runmares/core/widgets/route_map.dart';
import 'package:runmares/features/history/domain/activity_details.dart';
import 'package:runmares/features/recording/domain/pace_calculator.dart';
import 'package:runmares/features/recording/presentation/extensions/activity_type_presentation.dart';
import 'package:runmares/features/recording/presentation/extensions/route_segments_extension.dart';

class ShareableActivityCard extends StatelessWidget {
  const ShareableActivityCard({
    required this.details,
    this.unit = DistanceUnit.kilometers,
    super.key,
  });

  final ActivityDetails details;
  final DistanceUnit unit;

  @override
  Widget build(BuildContext context) {
    final summary = details.summary;
    final distance = MetricFormatters.distance(summary.distanceMeters, unit);
    final duration = MetricFormatters.duration(summary.duration);
    final avgPaceSec = PaceCalculator.secondsPerKilometer(
      distanceMeters: summary.distanceMeters,
      elapsed: summary.duration,
    );
    final pace = MetricFormatters.pace(avgPaceSec, unit);
    final formattedDate = MetricFormatters.dateTime(summary.startedAt);

    return Container(
      width: 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_run_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'RunMares',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                summary.type.label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 200,
              child: RouteMap(
                segments: details.segments.toLatLngSegments(),
                fitRoute: true,
                style: MapStyle.dark,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                label: 'DISTÂNCIA',
                value: '$distance ${unit.label}',
                isPrimary: true,
              ),
              _StatItem(
                label: 'PACE MÉDIO',
                value: '$pace /${unit.label}',
              ),
              _StatItem(
                label: 'TEMPO',
                value: duration,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderDark, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                '#RunMaresApp',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    this.isPrimary = false,
  });

  final String label;
  final String value;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: isPrimary ? AppColors.primary : Colors.white,
            fontSize: isPrimary ? 20 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
