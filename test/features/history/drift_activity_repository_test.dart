import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/core/database/app_database.dart';
import 'package:runmares/features/history/data/drift_activity_repository.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

TrackPoint _point(double latitude, int seconds) {
  return TrackPoint(
    latitude: latitude,
    longitude: 0,
    accuracyMeters: 5,
    timestamp: DateTime(2026).add(Duration(seconds: seconds)),
  );
}

RecordedActivity _activity() {
  return RecordedActivity(
    type: ActivityType.running,
    startedAt: DateTime(2026, 10, 3, 8),
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

  test('saves the activity and all of its route points', () async {
    await repository.save(_activity());

    final activities = await database.select(database.activityRecords).get();
    final points = await database.select(database.trackPointRecords).get();

    expect(activities, hasLength(1));
    expect(activities.single.type, ActivityType.running);
    expect(activities.single.durationSeconds, 300);
    expect(activities.single.distanceMeters, 1000);
    expect(points, hasLength(3));
    expect(points.map((point) => point.segmentIndex).toSet(), {0, 1});
  });

  test('removes the route points when the activity is deleted', () async {
    await repository.save(_activity());

    await database.delete(database.activityRecords).go();

    final points = await database.select(database.trackPointRecords).get();
    expect(points, isEmpty);
  });
}
