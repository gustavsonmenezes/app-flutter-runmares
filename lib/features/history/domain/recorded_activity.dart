import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

class RecordedActivity {
  const RecordedActivity({
    required this.type,
    required this.startedAt,
    required this.duration,
    required this.distanceMeters,
    required this.segments,
  });

  final ActivityType type;
  final DateTime startedAt;
  final Duration duration;
  final double distanceMeters;
  final List<List<TrackPoint>> segments;
}
