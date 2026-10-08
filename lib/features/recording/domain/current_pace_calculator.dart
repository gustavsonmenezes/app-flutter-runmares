import 'package:runmares/features/recording/domain/geo_distance.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

abstract final class CurrentPaceCalculator {
  static const Duration window = Duration(seconds: 30);
  static const Duration minDuration = Duration(seconds: 5);
  static const double minDistanceMeters = 10;
  static const double _metersPerKilometer = 1000;
  static const double _millisecondsPerSecond = 1000;

  /// Ritmo (segundos por quilômetro) dos últimos [window] de um trecho, ou
  /// `null` quando não há movimento suficiente para estimá-lo.
  static int? secondsPerKilometer(List<TrackPoint> segment) {
    if (segment.length < 2) return null;

    final lastIndex = segment.length - 1;
    final windowStart = segment[lastIndex].timestamp.subtract(window);

    var startIndex = lastIndex;
    while (startIndex > 0 &&
        !segment[startIndex - 1].timestamp.isBefore(windowStart)) {
      startIndex--;
    }
    if (startIndex == lastIndex) return null;

    var distance = 0.0;
    for (var index = startIndex + 1; index <= lastIndex; index++) {
      distance += GeoDistance.betweenMeters(segment[index - 1], segment[index]);
    }
    final duration = segment[lastIndex].timestamp.difference(
      segment[startIndex].timestamp,
    );

    if (duration < minDuration || distance < minDistanceMeters) return null;

    final seconds = duration.inMilliseconds / _millisecondsPerSecond;
    return (seconds / (distance / _metersPerKilometer)).round();
  }
}
