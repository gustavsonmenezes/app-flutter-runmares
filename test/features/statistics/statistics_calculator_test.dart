import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/statistics/domain/period_statistics.dart';
import 'package:runmares/features/statistics/domain/statistics_calculator.dart';

ActivitySummary _activity(DateTime startedAt, double meters, int minutes) {
  return ActivitySummary(
    id: startedAt.millisecondsSinceEpoch,
    type: ActivityType.running,
    startedAt: startedAt,
    duration: Duration(minutes: minutes),
    distanceMeters: meters,
  );
}

// 4/10/2026 é domingo, então a semana de 5/10 (segunda) a 11/10 (domingo)
// contém as atividades de 5, 7 e 11 de outubro.
final List<ActivitySummary> _activities = [
  _activity(DateTime(2026, 9, 30, 8), 9000, 60),
  _activity(DateTime(2026, 10, 4, 8), 3000, 20),
  _activity(DateTime(2026, 10, 5, 8), 5000, 30),
  _activity(DateTime(2026, 10, 7, 8), 2000, 20),
  _activity(DateTime(2026, 10, 11, 23), 1000, 10),
  _activity(DateTime(2026, 10, 12, 8), 4000, 25),
  _activity(DateTime(2026, 11, 1), 6000, 40),
];

void main() {
  group('week', () {
    final now = DateTime(2026, 10, 7, 12);

    PeriodStatistics week(DateTime reference) {
      return StatisticsCalculator.calculate(
        activities: _activities,
        period: StatisticsPeriod.week,
        now: reference,
      );
    }

    test('adds up only the activities of the current week', () {
      final statistics = week(now);

      expect(statistics.activityCount, 3);
      expect(statistics.totalDistanceMeters, 8000);
      expect(statistics.totalDuration, const Duration(minutes: 60));
    });

    test('has one bar per day, starting on Monday', () {
      final statistics = week(now);

      expect(statistics.buckets.map((bucket) => bucket.label), [
        'Seg',
        'Ter',
        'Qua',
        'Qui',
        'Sex',
        'Sáb',
        'Dom',
      ]);
      expect(statistics.buckets.map((bucket) => bucket.distanceMeters), [
        5000,
        0,
        2000,
        0,
        0,
        0,
        1000,
      ]);
    });

    test('a week that ends on Sunday can cross months', () {
      final statistics = week(DateTime(2026, 10, 4, 12));

      expect(statistics.activityCount, 2);
      expect(statistics.totalDistanceMeters, 12000);
    });

    test('knows the largest bar', () {
      expect(week(now).largestBucketMeters, 5000);
    });
  });

  group('month', () {
    PeriodStatistics month(DateTime reference) {
      return StatisticsCalculator.calculate(
        activities: _activities,
        period: StatisticsPeriod.month,
        now: reference,
      );
    }

    test('adds up only the activities of the current month', () {
      final statistics = month(DateTime(2026, 10, 7, 12));

      expect(statistics.activityCount, 5);
      expect(statistics.totalDistanceMeters, 15000);
      expect(statistics.totalDuration, const Duration(minutes: 105));
    });

    test('groups the days in blocks of seven', () {
      final statistics = month(DateTime(2026, 10, 7, 12));

      expect(statistics.buckets.map((bucket) => bucket.label), [
        '1–7',
        '8–14',
        '15–21',
        '22–28',
        '29–31',
      ]);
      expect(statistics.buckets.map((bucket) => bucket.distanceMeters), [
        10000,
        5000,
        0,
        0,
        0,
      ]);
    });

    test('a 28-day month has exactly four bars', () {
      final statistics = month(DateTime(2027, 2, 10));

      expect(statistics.buckets, hasLength(4));
      expect(statistics.buckets.last.label, '22–28');
    });
  });

  test('is empty when there are no activities in the period', () {
    final statistics = StatisticsCalculator.calculate(
      activities: const [],
      period: StatisticsPeriod.week,
      now: DateTime(2026, 10, 7),
    );

    expect(statistics.isEmpty, isTrue);
    expect(statistics.totalDistanceMeters, 0);
    expect(statistics.largestBucketMeters, 0);
  });
}
