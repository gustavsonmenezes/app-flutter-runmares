import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/recording_draft.dart';
import 'package:runmares/features/recording/domain/recording_draft_repository.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

class FakeRecordingDraftRepository implements RecordingDraftRepository {
  final Map<String, RecordingDraft> _drafts = {};

  void seed(RecordingDraft draft) => _drafts[draft.userId] = draft;

  RecordingDraft? draftOf(String userId) => _drafts[userId];

  @override
  Future<void> begin({
    required String userId,
    required ActivityType type,
    required DateTime startedAt,
  }) async {
    _drafts[userId] = RecordingDraft(
      userId: userId,
      type: type,
      startedAt: startedAt,
      elapsed: Duration.zero,
      segments: const [],
    );
  }

  @override
  Future<void> appendPoint({
    required String userId,
    required int segmentIndex,
    required TrackPoint point,
    required Duration elapsed,
  }) async {
    final current = _drafts[userId];
    if (current == null) return;

    final segments = [
      for (final segment in current.segments) List<TrackPoint>.of(segment),
    ];
    while (segments.length <= segmentIndex) {
      segments.add([]);
    }
    segments[segmentIndex].add(point);

    _drafts[userId] = RecordingDraft(
      userId: userId,
      type: current.type,
      startedAt: current.startedAt,
      elapsed: elapsed,
      segments: segments,
    );
  }

  @override
  Future<RecordingDraft?> find(String userId) async => _drafts[userId];

  @override
  Future<void> discard(String userId) async {
    _drafts.remove(userId);
  }
}
