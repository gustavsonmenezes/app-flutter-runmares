import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/formatters/metric_formatters.dart';

void main() {
  group('distance', () {
    test('uses a comma and two decimal places', () {
      expect(MetricFormatters.distance(1234), '1,23');
    });

    test('formats zero', () {
      expect(MetricFormatters.distance(0), '0,00');
    });

    test('converts to miles', () {
      expect(MetricFormatters.distance(5000, DistanceUnit.miles), '3,11');
    });
  });

  group('duration', () {
    test('shows minutes and seconds', () {
      expect(MetricFormatters.duration(const Duration(seconds: 65)), '01:05');
    });

    test('shows hours only when needed', () {
      expect(
        MetricFormatters.duration(const Duration(hours: 1, minutes: 2)),
        '1:02:00',
      );
    });
  });

  group('pace', () {
    test('formats seconds per kilometer as minutes and seconds', () {
      expect(MetricFormatters.pace(330), '5:30');
    });

    test('converts the pace to minutes per mile', () {
      expect(MetricFormatters.pace(330, DistanceUnit.miles), '8:51');
    });

    test('shows a placeholder when the pace is unknown', () {
      expect(MetricFormatters.pace(null), '--:--');
      expect(MetricFormatters.pace(null, DistanceUnit.miles), '--:--');
    });
  });

  group('dateTime', () {
    test('formats day, month, year and time', () {
      expect(
        MetricFormatters.dateTime(DateTime(2026, 10, 3, 8, 5)),
        '03/10/2026 08:05',
      );
    });
  });
}
