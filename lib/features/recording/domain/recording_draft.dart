import 'package:runmares/features/history/domain/recorded_activity.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/geo_distance.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

class RecordingDraft {
  const RecordingDraft({
    required this.userId,
    required this.type,
    required this.startedAt,
    required this.elapsed,
    required this.segments,
  });

  final String userId;
  final ActivityType type;
  final DateTime startedAt;
  final Duration elapsed;
  final List<List<TrackPoint>> segments;

  bool get hasPoints => segments.any((segment) => segment.isNotEmpty);

  // Só os pontos aceitos foram gravados, então somar os trechos entre pontos
  // consecutivos de cada segmento reproduz a distância da gravação.
  double get distanceMeters {
    var total = 0.0;
    for (final segment in segments) {
      for (var index = 1; index < segment.length; index++) {
        total += GeoDistance.betweenMeters(segment[index - 1], segment[index]);
      }
    }
    return total;
  }

  RecordedActivity toRecordedActivity() {
    return RecordedActivity(
      userId: userId,
      type: type,
      startedAt: startedAt,
      duration: elapsed,
      distanceMeters: distanceMeters,
      segments: segments,
    );
  }
}
