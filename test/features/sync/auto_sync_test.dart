import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/history/domain/pending_activity.dart';
import 'package:runmares/features/history/domain/recorded_activity.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/track_point.dart';
import 'package:runmares/features/sync/data/remote_activity_store_provider.dart';
import 'package:runmares/features/sync/presentation/providers/sync_providers.dart';

import '../auth/fakes/fake_auth_repository.dart';
import '../recording/fakes/fake_activity_repository.dart';
import 'fakes/fake_remote_activity_store.dart';

const AuthUser _user = AuthUser(uid: 'user-1', email: 'ana@exemplo.com');

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

Widget _host({
  required FakeAuthRepository auth,
  required FakeActivityRepository repository,
  required FakeRemoteActivityStore remote,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(auth),
      activityRepositoryProvider.overrideWithValue(repository),
      remoteActivityStoreProvider.overrideWithValue(remote),
    ],
    child: Consumer(
      builder: (context, ref, child) {
        ref.watch(autoSyncProvider);
        return const SizedBox();
      },
    ),
  );
}

void main() {
  late FakeAuthRepository auth;
  late FakeActivityRepository repository;
  late FakeRemoteActivityStore remote;

  setUp(() {
    auth = FakeAuthRepository(initialUser: _user);
    repository = FakeActivityRepository()..pending.add(_pending(1));
    remote = FakeRemoteActivityStore();
  });

  tearDown(() => auth.dispose());

  testWidgets('sends the pending activities as soon as it starts', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(auth: auth, repository: repository, remote: remote),
    );
    await tester.pump();

    expect(repository.syncedIds, [1]);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('retries after the retry interval when the first try fails', (
    tester,
  ) async {
    remote.shouldFail = true;
    await tester.pumpWidget(
      _host(auth: auth, repository: repository, remote: remote),
    );
    await tester.pump();
    expect(repository.syncedIds, isEmpty);

    remote.shouldFail = false;
    await tester.pump(syncRetryInterval);
    await tester.pump();

    expect(repository.syncedIds, [1]);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('tries again when the app comes back to the foreground', (
    tester,
  ) async {
    remote.shouldFail = true;
    await tester.pumpWidget(
      _host(auth: auth, repository: repository, remote: remote),
    );
    await tester.pump();
    expect(repository.syncedIds, isEmpty);

    remote.shouldFail = false;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    expect(repository.syncedIds, [1]);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('does not sync when nobody is logged in', (tester) async {
    await auth.signOut();

    await tester.pumpWidget(
      _host(auth: auth, repository: repository, remote: remote),
    );
    await tester.pump(syncRetryInterval);

    expect(repository.syncedIds, isEmpty);
    expect(remote.uploaded, isEmpty);
  });
}
