import 'package:drift/drift.dart';
import 'package:runmares/core/database/app_database.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/recording_draft.dart';
import 'package:runmares/features/recording/domain/recording_draft_repository.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

class DriftRecordingDraftRepository implements RecordingDraftRepository {
  const DriftRecordingDraftRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> begin({
    required String userId,
    required ActivityType type,
    required DateTime startedAt,
  }) {
    return _database.transaction(() async {
      // Apagar o rascunho anterior leva junto os pontos dele (cascade).
      await discard(userId);
      await _database
          .into(_database.draftSessions)
          .insert(
            DraftSessionsCompanion.insert(
              userId: userId,
              type: type,
              startedAt: startedAt,
            ),
          );
    });
  }

  @override
  Future<void> appendPoint({
    required String userId,
    required int segmentIndex,
    required TrackPoint point,
    required Duration elapsed,
  }) {
    return _database.transaction(() async {
      await _database
          .into(_database.draftPoints)
          .insert(
            DraftPointsCompanion.insert(
              userId: userId,
              segmentIndex: segmentIndex,
              latitude: point.latitude,
              longitude: point.longitude,
              accuracyMeters: point.accuracyMeters,
              recordedAt: point.timestamp,
            ),
          );
      await (_database.update(
        _database.draftSessions,
      )..where((table) => table.userId.equals(userId))).write(
        DraftSessionsCompanion(elapsedSeconds: Value(elapsed.inSeconds)),
      );
    });
  }

  @override
  Future<RecordingDraft?> find(String userId) async {
    final session = await (_database.select(
      _database.draftSessions,
    )..where((table) => table.userId.equals(userId))).getSingleOrNull();
    if (session == null) return null;

    final rows =
        await (_database.select(_database.draftPoints)
              ..where((table) => table.userId.equals(userId))
              ..orderBy([(table) => OrderingTerm.asc(table.id)]))
            .get();

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

    return RecordingDraft(
      userId: userId,
      type: session.type,
      startedAt: session.startedAt,
      elapsed: Duration(seconds: session.elapsedSeconds),
      segments: segments.values.toList(),
    );
  }

  @override
  Future<void> discard(String userId) async {
    await (_database.delete(
      _database.draftSessions,
    )..where((table) => table.userId.equals(userId))).go();
  }
}
