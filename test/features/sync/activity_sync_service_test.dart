import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/history/domain/pending_activity.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/track_point.dart';
import 'package:runmares/features/sync/domain/activity_sync_service.dart';

import '../recording/fakes/fake_activity_repository.dart';
import 'fakes/fake_remote_activity_store.dart';

PendingActivity _pending(int id) {
  return PendingActivity(
    id: id,
    activity: RecordedActivity(
      userId: 'user-1',
      type: ActivityType.running,
      startedAt: DateTime(2026, 10, id),
      duration: const Duration(minutes: 5),
      distanceMeters: 1000,
      segments: [
        [
          TrackPoint(
            latitude: 0,
            longitude: 0,
            accuracyMeters: 5,
            timestamp: DateTime(2026, 10, id),
          ),
        ],
      ],
    ),
  );
}

void main() {
  late FakeActivityRepository repository;
  late FakeRemoteActivityStore remote;
  late ActivitySyncService service;

  setUp(() {
    repository = FakeActivityRepository();
    remote = FakeRemoteActivityStore();
    service = ActivitySyncService(
      repository: repository,
      remote: remote,
      now: () => DateTime(2026, 10, 5),
    );
  });

  test('uploads every pending activity and marks it as synced', () async {
    repository.pending.addAll([_pending(1), _pending(2)]);

    final count = await service.syncPending('user-1');

    expect(count, 2);
    expect(remote.uploaded, hasLength(2));
    expect(repository.syncedIds, [1, 2]);
  });

  test('keeps the activities pending when the upload fails', () async {
    repository.pending.addAll([_pending(1), _pending(2)]);
    remote.shouldFail = true;

    final count = await service.syncPending('user-1');

    expect(count, 0);
    expect(repository.syncedIds, isEmpty);
    expect(repository.pending, hasLength(2));
  });

  test('sends the pending activities on the next attempt', () async {
    repository.pending.add(_pending(1));
    remote.shouldFail = true;
    await service.syncPending('user-1');

    remote.shouldFail = false;
    final count = await service.syncPending('user-1');

    expect(count, 1);
    expect(repository.syncedIds, [1]);
  });

  test('does nothing when there is nothing pending', () async {
    expect(await service.syncPending('user-1'), 0);
    expect(remote.uploaded, isEmpty);
  });

  test('does not run two syncs at the same time', () async {
    repository.pending.add(_pending(1));
    remote.gate = Completer<void>();

    final first = service.syncPending('user-1');
    final second = await service.syncPending('user-1');
    remote.gate!.complete();
    final firstCount = await first;

    expect(second, 0);
    expect(firstCount, 1);
    expect(remote.uploaded, hasLength(1));
  });
}
