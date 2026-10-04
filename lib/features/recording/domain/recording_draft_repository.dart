import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/recording_draft.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

abstract interface class RecordingDraftRepository {
  Future<void> begin({
    required String userId,
    required ActivityType type,
    required DateTime startedAt,
  });

  Future<void> appendPoint({
    required String userId,
    required int segmentIndex,
    required TrackPoint point,
    required Duration elapsed,
  });

  Future<RecordingDraft?> find(String userId);

  Future<void> discard(String userId);
}
