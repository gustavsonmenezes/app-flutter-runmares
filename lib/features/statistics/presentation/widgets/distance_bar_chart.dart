import 'package:fl_chart/fl_chart.dart';
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

  static const double _chartHeight = 160;

  @override
  Widget build(BuildContext context) {
    if (buckets.isEmpty) return const SizedBox(height: _chartHeight);

    final maxY = _calculateMaxY();

    return SizedBox(
      height: _chartHeight,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 8, left: 8),
        child: BarChart(
          BarChartData(
            maxY: maxY,
            alignment: BarChartAlignment.spaceAround,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) =>
                    Theme.of(context).colorScheme.surface,
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                tooltipMargin: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final bucket = buckets[groupIndex];
                  final distance = MetricFormatters.distance(
                    bucket.distanceMeters,
                    unit,
                  );
                  return BarTooltipItem(
                    '$distance ${unit.label}',
                    TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= buckets.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        buckets[index].label,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: [
              for (var index = 0; index < buckets.length; index++)
                BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: _valueInUnit(buckets[index].distanceMeters),
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFFFF9E00)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      width: 16,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY,
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _valueInUnit(double distanceMeters) {
    return unit == DistanceUnit.miles
        ? distanceMeters / 1609.344
        : distanceMeters / 1000.0;
  }

  double _calculateMaxY() {
    final maxInUnit = _valueInUnit(largestBucketMeters);
    if (maxInUnit <= 0) return 10.0;
    return maxInUnit * 1.2;
  }
}
