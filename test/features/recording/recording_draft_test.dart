import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/recording_draft.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

TrackPoint _point(double latitude, int seconds) {
  return TrackPoint(
    latitude: latitude,
    longitude: 0,
    accuracyMeters: 5,
    timestamp: DateTime(2026).add(Duration(seconds: seconds)),
  );
}

RecordingDraft _draft(List<List<TrackPoint>> segments) {
  return RecordingDraft(
    userId: 'user-1',
    type: ActivityType.walking,
    startedAt: DateTime(2026, 10, 4, 9),
    elapsed: const Duration(minutes: 12),
    segments: segments,
  );
}

void main() {
  test('has no points when the segments are empty', () {
    expect(_draft(const []).hasPoints, isFalse);
    expect(_draft([[]]).hasPoints, isFalse);
  });

  test('has points when any segment has one', () {
    expect(
      _draft([
        [_point(0, 0)],
      ]).hasPoints,
      isTrue,
    );
  });

  test('measures the distance inside each segment only', () {
    final draft = _draft([
      [_point(0, 0), _point(0.001, 30)],
      [_point(0.5, 600), _point(0.501, 630)],
    ]);

    expect(draft.distanceMeters, closeTo(222.4, 1));
  });

  test('converts to a recorded activity', () {
    final draft = _draft([
      [_point(0, 0), _point(0.001, 30)],
    ]);

    final activity = draft.toRecordedActivity();

    expect(activity.userId, 'user-1');
    expect(activity.type, ActivityType.walking);
    expect(activity.startedAt, DateTime(2026, 10, 4, 9));
    expect(activity.duration, const Duration(minutes: 12));
    expect(activity.distanceMeters, closeTo(111.2, 0.5));
    expect(activity.segments, hasLength(1));
  });
}
