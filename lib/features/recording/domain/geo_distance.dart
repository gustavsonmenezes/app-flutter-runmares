import 'dart:math' as math;

import 'package:runmares/features/recording/domain/track_point.dart';

abstract final class GeoDistance {
  static const double _earthRadiusMeters = 6371000;

  static double betweenMeters(TrackPoint from, TrackPoint to) {
    final deltaLatitude = _toRadians(to.latitude - from.latitude);
    final deltaLongitude = _toRadians(to.longitude - from.longitude);

    final haversine =
        math.pow(math.sin(deltaLatitude / 2), 2) +
        math.cos(_toRadians(from.latitude)) *
            math.cos(_toRadians(to.latitude)) *
            math.pow(math.sin(deltaLongitude / 2), 2);

    final centralAngle = 2 * math.asin(math.min(1.0, math.sqrt(haversine)));
    return _earthRadiusMeters * centralAngle;
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180;
}
