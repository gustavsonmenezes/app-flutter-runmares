import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/recording/domain/pace_calculator.dart';

void main() {
  test('is unknown before the minimum distance', () {
    final pace = PaceCalculator.secondsPerKilometer(
      distanceMeters: 30,
      elapsed: const Duration(minutes: 1),
    );

    expect(pace, isNull);
  });

  test('is unknown when no time has passed', () {
    final pace = PaceCalculator.secondsPerKilometer(
      distanceMeters: 500,
      elapsed: Duration.zero,
    );

    expect(pace, isNull);
  });

  test('calculates 5:30 per km for 1 km in 5 minutes and 30 seconds', () {
    final pace = PaceCalculator.secondsPerKilometer(
      distanceMeters: 1000,
      elapsed: const Duration(minutes: 5, seconds: 30),
    );

    expect(pace, 330);
  });

  test('calculates 6:00 per km for 500 m in 3 minutes', () {
    final pace = PaceCalculator.secondsPerKilometer(
      distanceMeters: 500,
      elapsed: const Duration(minutes: 3),
    );

    expect(pace, 360);
  });
}
