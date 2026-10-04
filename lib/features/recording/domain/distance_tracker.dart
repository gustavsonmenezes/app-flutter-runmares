import 'package:runmares/features/recording/domain/geo_distance.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

class DistanceTracker {
  static const double maxAccuracyMeters = 25;
  static const double maxSpeedMetersPerSecond = 20;
  static const double minMovementMeters = 3;

  final List<List<TrackPoint>> _segments = [];
  double _totalMeters = 0;
  bool _hasAcceptedPoint = false;
  TrackPoint? _lastPoint;

  double get totalMeters => _totalMeters;

  bool get hasAcceptedPoint => _hasAcceptedPoint;

  List<List<TrackPoint>> get segments =>
      List.unmodifiable(_segments.map(List<TrackPoint>.unmodifiable));

  void add(TrackPoint point) {
    if (point.accuracyMeters > maxAccuracyMeters) return;

    final last = _lastPoint;
    if (last == null) {
      _segments.add([point]);
      _lastPoint = point;
      _hasAcceptedPoint = true;
      return;
    }

    final elapsedSeconds =
        point.timestamp.difference(last.timestamp).inMilliseconds / 1000;
    if (elapsedSeconds <= 0) return;

    final distance = GeoDistance.betweenMeters(last, point);
    if (distance / elapsedSeconds > maxSpeedMetersPerSecond) return;
    if (distance < minMovementMeters) return;

    _totalMeters += distance;
    _segments.last.add(point);
    _lastPoint = point;
  }

  void startNewSegment() {
    _lastPoint = null;
  }

  void reset() {
    _totalMeters = 0;
    _hasAcceptedPoint = false;
    _lastPoint = null;
    _segments.clear();
  }
}
