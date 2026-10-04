import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

class ActivityDetails {
  const ActivityDetails({required this.summary, required this.segments});

  final ActivitySummary summary;
  final List<List<TrackPoint>> segments;
}
