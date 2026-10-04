import 'dart:math' as math;

import 'package:runmares/features/history/domain/recorded_activity.dart';

abstract final class ActivityDocumentMapper {
  static const int chunkSize = 500;

  static String documentId(RecordedActivity activity) {
    return activity.startedAt.millisecondsSinceEpoch.toString();
  }

  static Map<String, Object> activityData(RecordedActivity activity) {
    final pointCount = activity.segments.fold<int>(
      0,
      (total, segment) => total + segment.length,
    );

    return {
      'type': activity.type.name,
      'startedAtMillis': activity.startedAt.millisecondsSinceEpoch,
      'durationSeconds': activity.duration.inSeconds,
      'distanceMeters': activity.distanceMeters,
      'pointCount': pointCount,
      'chunkCount': (pointCount / chunkSize).ceil(),
    };
  }

  static List<List<Map<String, Object>>> routeChunks(
    RecordedActivity activity,
  ) {
    final points = <Map<String, Object>>[
      for (var index = 0; index < activity.segments.length; index++)
        for (final point in activity.segments[index])
          {
            'segment': index,
            'lat': point.latitude,
            'lng': point.longitude,
            'accuracy': point.accuracyMeters,
            'timeMillis': point.timestamp.millisecondsSinceEpoch,
          },
    ];

    return [
      for (var start = 0; start < points.length; start += chunkSize)
        points.sublist(start, math.min(start + chunkSize, points.length)),
    ];
  }
}
