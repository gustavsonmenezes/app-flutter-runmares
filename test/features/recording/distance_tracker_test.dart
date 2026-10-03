import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/recording/domain/distance_tracker.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

TrackPoint _point(double latitude, int seconds, {double accuracy = 5}) {
  return TrackPoint(
    latitude: latitude,
    longitude: 0,
    accuracyMeters: accuracy,
    timestamp: DateTime(2026).add(Duration(seconds: seconds)),
  );
}

void main() {
  late DistanceTracker tracker;

  setUp(() => tracker = DistanceTracker());

  test('the first point does not add distance', () {
    tracker.add(_point(0, 0));

    expect(tracker.totalMeters, 0);
    expect(tracker.hasAcceptedPoint, isTrue);
  });

  test('adds the distance between two points', () {
    tracker.add(_point(0, 0));
    tracker.add(_point(0.001, 30));

    expect(tracker.totalMeters, closeTo(111.2, 0.5));
  });

  test('discards points with poor accuracy', () {
    tracker.add(_point(0, 0));
    tracker.add(_point(0.001, 30, accuracy: 50));

    expect(tracker.totalMeters, 0);
  });

  test('discards impossible jumps', () {
    tracker.add(_point(0, 0));
    tracker.add(_point(1, 1));

    expect(tracker.totalMeters, 0);
  });

  test('ignores jitter smaller than the minimum movement', () {
    tracker.add(_point(0, 0));
    tracker.add(_point(0.00001, 10));

    expect(tracker.totalMeters, 0);
  });

  test('does not count the gap between segments', () {
    tracker.add(_point(0, 0));
    tracker.startNewSegment();
    tracker.add(_point(0.5, 600));

    expect(tracker.totalMeters, 0);
  });

  test('reset clears everything', () {
    tracker.add(_point(0, 0));
    tracker.add(_point(0.001, 30));

    tracker.reset();

    expect(tracker.totalMeters, 0);
    expect(tracker.hasAcceptedPoint, isFalse);
  });

  test('keeps accepted points in a single segment', () {
    tracker.add(_point(0, 0));
    tracker.add(_point(0.001, 30));

    expect(tracker.segments, hasLength(1));
    expect(tracker.segments.first, hasLength(2));
  });

  test('does not store discarded points', () {
    tracker.add(_point(0, 0));
    tracker.add(_point(0.001, 30, accuracy: 50));

    expect(tracker.segments.single, hasLength(1));
  });

  test('starts a new segment after startNewSegment', () {
    tracker.add(_point(0, 0));
    tracker.startNewSegment();
    tracker.add(_point(0.5, 600));

    expect(tracker.segments, hasLength(2));
  });
}
