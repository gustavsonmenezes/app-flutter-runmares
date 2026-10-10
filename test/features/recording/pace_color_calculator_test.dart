import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/app/theme/app_colors.dart';
import 'package:runmares/features/recording/domain/pace_color_calculator.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

TrackPoint _point(double lat, double lon, int seconds) {
  return TrackPoint(
    latitude: lat,
    longitude: lon,
    accuracyMeters: 5,
    timestamp: DateTime(2026, 10, 1, 8, 0, seconds),
  );
}

void main() {
  group('PaceColorCalculator', () {
    test('returns empty list for segments with less than 2 points', () {
      final segments = [
        [_point(0, 0, 0)],
      ];

      final result = PaceColorCalculator.calculateSegments(segments);

      expect(result, isEmpty);
    });

    test('calculates colored segments with fast pace (green)', () {
      // 100 meters in 20 seconds -> 20s / 0.1km = 200 s/km (< 300s -> fast/green)
      final p1 = _point(0, 0, 0);
      final p2 = _point(0.0009, 0, 20);

      final result = PaceColorCalculator.calculateSegments([
        [p1, p2],
      ]);

      expect(result.length, 1);
      expect(result.first.color, AppColors.accentSuccess);
    });

    test('calculates colored segments with slow pace (red)', () {
      // 10 meters in 30 seconds -> 30s / 0.01km = 3000 s/km (> 390s -> slow/red)
      final p1 = _point(0, 0, 0);
      final p2 = _point(0.00009, 0, 30);

      final result = PaceColorCalculator.calculateSegments([
        [p1, p2],
      ]);

      expect(result.length, 1);
      expect(result.first.color, const Color(0xFFEF4444));
    });
  });
}
