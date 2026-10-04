import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/core/database/app_database.dart';
import 'package:runmares/features/history/data/drift_activity_repository.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

const String _ana = 'user-ana';
const String _bruno = 'user-bruno';

TrackPoint _point(double latitude, int seconds) {
  return TrackPoint(
    latitude: latitude,
    longitude: 0,
    accuracyMeters: 5,
    timestamp: DateTime(2026).add(Duration(seconds: seconds)),
  );
}

RecordedActivity _activity({String userId = _ana, DateTime? startedAt}) {
  return RecordedActivity(
    userId: userId,
    type: ActivityType.running,
    startedAt: startedAt ?? DateTime(2026, 10, 3, 8),
    duration: const Duration(minutes: 5),
    distanceMeters: 1000,
    segments: [
      [_point(0, 0), _point(0.001, 30)],
      [_point(0.5, 600)],
    ],
  );
}

void main() {
  late AppDatabase database;
  late DriftActivityRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftActivityRepository(database);
  });

  tearDown(() => database.close());

  test('saves the activity, its owner and all of its route points', () async {
    await repository.save(_activity());

    final activities = await database.select(database.activityRecords).get();
    final points = await database.select(database.trackPointRecords).get();

    expect(activities, hasLength(1));
    expect(activities.single.userId, _ana);
    expect(activities.single.type, ActivityType.running);
    expect(activities.single.durationSeconds, 300);
    expect(activities.single.distanceMeters, 1000);
    expect(activities.single.syncedAt, isNull);
    expect(points, hasLength(3));
    expect(points.map((point) => point.segmentIndex).toSet(), {0, 1});
  });

  test('removes the route points when the activity is deleted', () async {
    await repository.save(_activity());

    await database.delete(database.activityRecords).go();

    final points = await database.select(database.trackPointRecords).get();
    expect(points, isEmpty);
  });

  test('lists the activities from the newest to the oldest', () async {
    final older = DateTime(2026, 10, 1, 8);
    final newer = DateTime(2026, 10, 3, 8);
    await repository.save(_activity(startedAt: older));
    await repository.save(_activity(startedAt: newer));

    final summaries = await repository.watchSummaries(_ana).first;

    expect(summaries.map((summary) => summary.startedAt), [newer, older]);
  });

  test('lists only the activities of the given user', () async {
    await repository.save(_activity());
    await repository.save(_activity(userId: _bruno));

    final summaries = await repository.watchSummaries(_bruno).first;

    expect(summaries, hasLength(1));
  });

  test('loads the details with the route grouped by segment', () async {
    final id = await repository.save(_activity());

    final details = await repository.findDetails(id, userId: _ana);

    expect(details, isNotNull);
    expect(details!.summary.distanceMeters, 1000);
    expect(details.summary.duration, const Duration(minutes: 5));
    expect(details.segments, hasLength(2));
    expect(details.segments.first, hasLength(2));
    expect(details.segments.last, hasLength(1));
  });

  test('returns null for an unknown activity', () async {
    expect(await repository.findDetails(999, userId: _ana), isNull);
  });

  test('does not load the activity of another user', () async {
    final id = await repository.save(_activity());

    expect(await repository.findDetails(id, userId: _bruno), isNull);
  });

  test('lists only the activities that were not synced yet', () async {
    final syncedId = await repository.save(
      _activity(startedAt: DateTime(2026, 10, 1)),
    );
    await repository.save(_activity(startedAt: DateTime(2026, 10, 2)));
    await repository.markSynced(syncedId, DateTime(2026, 10, 5));

    final pending = await repository.findPending(_ana);

    expect(pending, hasLength(1));
    expect(pending.single.activity.startedAt, DateTime(2026, 10, 2));
  });

  test('pending activities carry their route and owner', () async {
    await repository.save(_activity());

    final pending = await repository.findPending(_ana);

    expect(pending.single.activity.userId, _ana);
    expect(pending.single.activity.segments, hasLength(2));
  });

  test('does not list the pending activities of another user', () async {
    await repository.save(_activity());

    expect(await repository.findPending(_bruno), isEmpty);
  });

  test('shows the synced state in the summaries', () async {
    final id = await repository.save(_activity());
    final before = await repository.watchSummaries(_ana).first;
    expect(before.single.isSynced, isFalse);

    await repository.markSynced(id, DateTime(2026, 10, 5));

    final after = await repository.watchSummaries(_ana).first;
    expect(after.single.isSynced, isTrue);
  });
}
