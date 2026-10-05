import 'dart:math' as math;

enum StatisticsPeriod { week, month }

class StatisticsBucket {
  const StatisticsBucket({required this.label, required this.distanceMeters});

  final String label;
  final double distanceMeters;
}

class PeriodStatistics {
  const PeriodStatistics({
    required this.totalDistanceMeters,
    required this.totalDuration,
    required this.activityCount,
    required this.buckets,
  });

  final double totalDistanceMeters;
  final Duration totalDuration;
  final int activityCount;
  final List<StatisticsBucket> buckets;

  bool get isEmpty => activityCount == 0;

  double get largestBucketMeters {
    return buckets.fold(
      0.0,
      (largest, bucket) => math.max(largest, bucket.distanceMeters),
    );
  }
}
