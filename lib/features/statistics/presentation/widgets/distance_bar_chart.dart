import 'package:flutter/material.dart';
import 'package:runmares/app/theme/app_colors.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/formatters/metric_formatters.dart';
import 'package:runmares/features/statistics/domain/period_statistics.dart';

class DistanceBarChart extends StatelessWidget {
  const DistanceBarChart({
    required this.buckets,
    required this.largestBucketMeters,
    this.unit = DistanceUnit.kilometers,
    super.key,
  });

  final List<StatisticsBucket> buckets;
  final double largestBucketMeters;
  final DistanceUnit unit;

  static const double _plotHeight = 140;
  static const double _barWidth = 22;
  static const double _barRadius = 4;
  static const double _labelGap = 6;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodySmall;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final bucket in buckets)
          Expanded(
            child: Semantics(
              label: '${bucket.label}: ${_distanceOf(bucket)} ${unit.label}',
              excludeSemantics: true,
              child: Column(
                children: [
                  SizedBox(
                    height: _plotHeight,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: _barWidth,
                        child: FractionallySizedBox(
                          heightFactor: _heightFactor(bucket),
                          alignment: Alignment.bottomCenter,
                          child: const DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(_barRadius),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: _labelGap),
                  Text(
                    bucket.label,
                    style: labelStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _distanceOf(StatisticsBucket bucket) {
    return MetricFormatters.distance(bucket.distanceMeters, unit);
  }

  double _heightFactor(StatisticsBucket bucket) {
    if (largestBucketMeters <= 0) return 0;
    return bucket.distanceMeters / largestBucketMeters;
  }
}
