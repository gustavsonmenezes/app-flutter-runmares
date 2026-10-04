import 'dart:math' as math;

import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/statistics/domain/period_statistics.dart';

abstract final class StatisticsCalculator {
  static const List<String> _weekdayLabels = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
    'Dom',
  ];
  static const int _daysPerWeek = 7;

  static PeriodStatistics calculate({
    required List<ActivitySummary> activities,
    required StatisticsPeriod period,
    required DateTime now,
  }) {
    return switch (period) {
      StatisticsPeriod.week => _week(activities, now),
      StatisticsPeriod.month => _month(activities, now),
    };
  }

  static PeriodStatistics _week(
    List<ActivitySummary> activities,
    DateTime now,
  ) {
    final start = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final end = DateTime(start.year, start.month, start.day + _daysPerWeek);

    return _summarize(
      activities.where((item) => _isWithin(item.startedAt, start, end)),
      labels: _weekdayLabels,
      bucketOf: (item) => item.startedAt.weekday - 1,
    );
  }

  static PeriodStatistics _month(
    List<ActivitySummary> activities,
    DateTime now,
  ) {
    final start = DateTime(now.year, now.month);
    final end = DateTime(now.year, now.month + 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final bucketCount = (daysInMonth - 1) ~/ _daysPerWeek + 1;
    final labels = [
      for (var index = 0; index < bucketCount; index++)
        '${index * _daysPerWeek + 1}–'
            '${math.min((index + 1) * _daysPerWeek, daysInMonth)}',
    ];

    return _summarize(
      activities.where((item) => _isWithin(item.startedAt, start, end)),
      labels: labels,
      bucketOf: (item) => (item.startedAt.day - 1) ~/ _daysPerWeek,
    );
  }

  static bool _isWithin(DateTime value, DateTime start, DateTime end) {
    return !value.isBefore(start) && value.isBefore(end);
  }

  static PeriodStatistics _summarize(
    Iterable<ActivitySummary> activities, {
    required List<String> labels,
    required int Function(ActivitySummary) bucketOf,
  }) {
    final distances = List<double>.filled(labels.length, 0);
    var totalDistance = 0.0;
    var totalDuration = Duration.zero;
    var count = 0;

    for (final item in activities) {
      distances[bucketOf(item)] += item.distanceMeters;
      totalDistance += item.distanceMeters;
      totalDuration += item.duration;
      count++;
    }

    return PeriodStatistics(
      totalDistanceMeters: totalDistance,
      totalDuration: totalDuration,
      activityCount: count,
      buckets: [
        for (var index = 0; index < labels.length; index++)
          StatisticsBucket(
            label: labels[index],
            distanceMeters: distances[index],
          ),
      ],
    );
  }
}
