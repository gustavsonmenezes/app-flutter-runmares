import 'package:drift/drift.dart';
import 'package:runmares/core/database/app_database.dart';
import 'package:runmares/features/history/domain/activity_details.dart';
import 'package:runmares/features/history/domain/activity_repository.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

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
              userId: activity.userId,
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

  @override
  Stream<List<ActivitySummary>> watchSummaries(String userId) {
    final query = _database.select(_database.activityRecords)
      ..where((table) => table.userId.equals(userId))
      ..orderBy([(table) => OrderingTerm.desc(table.startedAt)]);

    return query.watch().map((rows) => rows.map(_toSummary).toList());
  }

  @override
  Future<ActivityDetails?> findDetails(int id, {required String userId}) async {
    final record =
        await (_database.select(_database.activityRecords)..where(
              (table) => table.id.equals(id) & table.userId.equals(userId),
            ))
            .getSingleOrNull();
    if (record == null) return null;

    // Os pontos foram gravados em ordem, então o id preserva a sequência.
    final pointRows =
        await (_database.select(_database.trackPointRecords)
              ..where((table) => table.activityId.equals(id))
              ..orderBy([(table) => OrderingTerm.asc(table.id)]))
            .get();

    return ActivityDetails(
      summary: _toSummary(record),
      segments: _groupBySegment(pointRows),
    );
  }

  ActivitySummary _toSummary(ActivityRecord record) {
    return ActivitySummary(
      id: record.id,
      type: record.type,
      startedAt: record.startedAt,
      duration: Duration(seconds: record.durationSeconds),
      distanceMeters: record.distanceMeters,
    );
  }

  List<List<TrackPoint>> _groupBySegment(List<TrackPointRecord> rows) {
    final segments = <int, List<TrackPoint>>{};
    for (final row in rows) {
      segments
          .putIfAbsent(row.segmentIndex, () => [])
          .add(
            TrackPoint(
              latitude: row.latitude,
              longitude: row.longitude,
              accuracyMeters: row.accuracyMeters,
              timestamp: row.recordedAt,
            ),
          );
    }
    return segments.values.toList();
  }
}
