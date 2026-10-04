import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/track_point.dart';
import 'package:runmares/features/sync/data/activity_document_mapper.dart';

TrackPoint _point(int index) {
  return TrackPoint(
    latitude: index / 1000,
    longitude: 0,
    accuracyMeters: 5,
    timestamp: DateTime(2026).add(Duration(seconds: index)),
  );
}

RecordedActivity _activity(List<List<TrackPoint>> segments) {
  return RecordedActivity(
    userId: 'user-1',
    type: ActivityType.walking,
    startedAt: DateTime.fromMillisecondsSinceEpoch(1760000000000),
    duration: const Duration(minutes: 10),
    distanceMeters: 800,
    segments: segments,
  );
}

void main() {
  test('uses the start time in milliseconds as the document id', () {
    expect(ActivityDocumentMapper.documentId(_activity([])), '1760000000000');
  });

  test('describes the activity', () {
    final data = ActivityDocumentMapper.activityData(
      _activity([
        [_point(0), _point(1)],
        [_point(2)],
      ]),
    );

    expect(data['type'], 'walking');
    expect(data['durationSeconds'], 600);
    expect(data['distanceMeters'], 800);
    expect(data['pointCount'], 3);
    expect(data['chunkCount'], 1);
  });

  test('tags each point with its segment, in order', () {
    final chunks = ActivityDocumentMapper.routeChunks(
      _activity([
        [_point(0), _point(1)],
        [_point(2)],
      ]),
    );

    expect(chunks, hasLength(1));
    expect(chunks.single.map((point) => point['segment']), [0, 0, 1]);
  });

  test('splits a long route into chunks of at most 500 points', () {
    final route = [for (var i = 0; i < 1201; i++) _point(i)];

    final chunks = ActivityDocumentMapper.routeChunks(_activity([route]));

    expect(chunks.map((chunk) => chunk.length), [500, 500, 201]);
    expect(
      ActivityDocumentMapper.activityData(_activity([route]))['chunkCount'],
      3,
    );
  });

  test('has no chunks when there are no points', () {
    expect(ActivityDocumentMapper.routeChunks(_activity([])), isEmpty);
  });
}
