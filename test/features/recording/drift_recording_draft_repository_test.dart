import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/core/database/app_database.dart';
import 'package:runmares/features/recording/data/drift_recording_draft_repository.dart';
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

void main() {
  late AppDatabase database;
  late DriftRecordingDraftRepository repository;

  Future<void> begin(String userId) {
    return repository.begin(
      userId: userId,
      type: ActivityType.running,
      startedAt: DateTime(2026, 10, 4, 8),
    );
  }

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRecordingDraftRepository(database);
  });

  tearDown(() => database.close());

  test('stores the draft with its points in order', () async {
    await begin(_ana);
    await repository.appendPoint(
      userId: _ana,
      segmentIndex: 0,
      point: _point(0, 0),
      elapsed: const Duration(seconds: 5),
    );
    await repository.appendPoint(
      userId: _ana,
      segmentIndex: 0,
      point: _point(0.001, 30),
      elapsed: const Duration(seconds: 30),
    );
    await repository.appendPoint(
      userId: _ana,
      segmentIndex: 1,
      point: _point(0.5, 600),
      elapsed: const Duration(seconds: 60),
    );

    final draft = await repository.find(_ana);

    expect(draft, isNotNull);
    expect(draft!.type, ActivityType.running);
    expect(draft.startedAt, DateTime(2026, 10, 4, 8));
    expect(draft.elapsed, const Duration(seconds: 60));
    expect(draft.segments, hasLength(2));
    expect(draft.segments.first, hasLength(2));
    expect(draft.segments.last, hasLength(1));
  });

  test('beginning again replaces the previous draft and its points', () async {
    await begin(_ana);
    await repository.appendPoint(
      userId: _ana,
      segmentIndex: 0,
      point: _point(0, 0),
      elapsed: const Duration(seconds: 5),
    );

    await begin(_ana);

    final draft = await repository.find(_ana);
    expect(draft, isNotNull);
    expect(draft!.hasPoints, isFalse);
    expect(await database.select(database.draftPoints).get(), isEmpty);
  });

  test('discard removes the draft and its points', () async {
    await begin(_ana);
    await repository.appendPoint(
      userId: _ana,
      segmentIndex: 0,
      point: _point(0, 0),
      elapsed: const Duration(seconds: 5),
    );

    await repository.discard(_ana);

    expect(await repository.find(_ana), isNull);
    expect(await database.select(database.draftPoints).get(), isEmpty);
  });

  test('keeps the drafts of different users apart', () async {
    await begin(_ana);
    await begin(_bruno);
    await repository.appendPoint(
      userId: _ana,
      segmentIndex: 0,
      point: _point(0, 0),
      elapsed: const Duration(seconds: 5),
    );

    final bruno = await repository.find(_bruno);

    expect(bruno, isNotNull);
    expect(bruno!.hasPoints, isFalse);
  });

  test('finds nothing when there is no draft', () async {
    expect(await repository.find(_ana), isNull);
  });
}
