abstract final class PaceCalculator {
  static const double minDistanceMeters = 50;
  static const double _metersPerKilometer = 1000;
  static const double _millisecondsPerSecond = 1000;

  static int? secondsPerKilometer({
    required double distanceMeters,
    required Duration elapsed,
  }) {
    if (distanceMeters < minDistanceMeters) return null;

    final seconds = elapsed.inMilliseconds / _millisecondsPerSecond;
    if (seconds <= 0) return null;

    return (seconds / (distanceMeters / _metersPerKilometer)).round();
  }
}
