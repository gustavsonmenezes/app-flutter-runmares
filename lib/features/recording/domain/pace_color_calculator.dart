import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:runmares/app/theme/app_colors.dart';
import 'package:runmares/features/recording/domain/colored_route_segment.dart';
import 'package:runmares/features/recording/domain/geo_distance.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

abstract final class PaceColorCalculator {
  static const int _fastThresholdSec = 300;
  static const int _moderateThresholdSec = 390;

  static List<ColoredRouteSegment> calculateSegments(
    List<List<TrackPoint>> segments,
  ) {
    final result = <ColoredRouteSegment>[];

    for (final segment in segments) {
      if (segment.length < 2) continue;

      for (var i = 0; i < segment.length - 1; i++) {
        final p1 = segment[i];
        final p2 = segment[i + 1];

        final distMeters = GeoDistance.betweenMeters(p1, p2);
        final durationSec = p2.timestamp.difference(p1.timestamp).inSeconds;

        int? paceSec;
        if (distMeters > 0.5 && durationSec > 0) {
          paceSec = ((durationSec / distMeters) * 1000).round();
        }

        final color = _colorForPace(paceSec);

        result.add(
          ColoredRouteSegment(
            points: [
              LatLng(p1.latitude, p1.longitude),
              LatLng(p2.latitude, p2.longitude),
            ],
            color: color,
            paceSecondsPerKm: paceSec,
          ),
        );
      }
    }

    return result;
  }

  static Color _colorForPace(int? paceSecondsPerKm) {
    if (paceSecondsPerKm == null || paceSecondsPerKm <= 0) {
      return AppColors.primary;
    }

    if (paceSecondsPerKm < _fastThresholdSec) {
      return AppColors.accentSuccess;
    } else if (paceSecondsPerKm <= _moderateThresholdSec) {
      return AppColors.accentWarning;
    } else {
      return const Color(0xFFEF4444);
    }
  }
}
