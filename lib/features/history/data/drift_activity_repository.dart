import 'package:runmares/core/database/app_database.dart';
import 'package:runmares/features/history/domain/activity_repository.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';

class DriftActivityRepository implements ActivityRepository {
  const DriftActivityRepository(this._database);

  final AppDatabase _database;

  @override
  Future<int> save(RecordedActivity activity) {
    return _database.transaction(() async {
      final activityId = await _database
          .into(_database.activityRecords)
          .insert(
            ActivityRecordsCompanion.insert(
              type: activity.type,
              startedAt: activity.startedAt,
              durationSeconds: activity.duration.inSeconds,
              distanceMeters: activity.distanceMeters,
            ),
          );

      await _database.batch((batch) {
        batch.insertAll(_database.trackPointRecords, [
          for (var index = 0; index < activity.segments.length; index++)
            for (final point in activity.segments[index])
              TrackPointRecordsCompanion.insert(
                activityId: activityId,
                segmentIndex: index,
                latitude: point.latitude,
                longitude: point.longitude,
                accuracyMeters: point.accuracyMeters,
                recordedAt: point.timestamp,
              ),
        ]);
      });

      return activityId;
    });
  }
}
