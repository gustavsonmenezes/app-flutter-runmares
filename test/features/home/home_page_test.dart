import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/home/presentation/pages/home_page.dart';
import 'package:runmares/features/recording/data/recording_draft_repository_provider.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/recording_draft.dart';
import 'package:runmares/features/recording/domain/track_point.dart';
import 'package:runmares/features/sync/data/remote_activity_store_provider.dart';

import '../auth/fakes/fake_auth_repository.dart';
import '../recording/fakes/fake_activity_repository.dart';
import '../recording/fakes/fake_recording_draft_repository.dart';
import '../sync/fakes/fake_remote_activity_store.dart';

TrackPoint _point(double latitude, int seconds) {
  return TrackPoint(
    latitude: latitude,
    longitude: 0,
    accuracyMeters: 5,
    timestamp: DateTime(2026).add(Duration(seconds: seconds)),
  );
}

RecordingDraft _draft({bool withPoints = true}) {
  return RecordingDraft(
    userId: 'user-1',
    type: ActivityType.walking,
    startedAt: DateTime(2026, 10, 4, 9),
    elapsed: const Duration(minutes: 12),
    segments: withPoints
        ? [
            [_point(0, 0), _point(0.001, 30)],
          ]
        : const [],
  );
}

Future<void> _pumpHome(
  WidgetTester tester, {
  required FakeRecordingDraftRepository drafts,
  required FakeActivityRepository activities,
}) async {
  final auth = FakeAuthRepository(
    initialUser: const AuthUser(uid: 'user-1', email: 'ana@exemplo.com'),
  );
  addTearDown(auth.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        activityRepositoryProvider.overrideWithValue(activities),
        recordingDraftRepositoryProvider.overrideWithValue(drafts),
        remoteActivityStoreProvider.overrideWithValue(
          FakeRemoteActivityStore(),
        ),
      ],
      child: const MaterialApp(home: HomePage()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  late FakeRecordingDraftRepository drafts;
  late FakeActivityRepository activities;

  setUp(() {
    drafts = FakeRecordingDraftRepository();
    activities = FakeActivityRepository();
  });

  testWidgets('does not ask anything when there is no interrupted activity', (
    tester,
  ) async {
    await _pumpHome(tester, drafts: drafts, activities: activities);

    expect(find.text('Atividade interrompida'), findsNothing);
  });

  testWidgets('offers to save an interrupted activity and saves it', (
    tester,
  ) async {
    drafts.seed(_draft());

    await _pumpHome(tester, drafts: drafts, activities: activities);
    expect(find.text('Atividade interrompida'), findsOneWidget);

    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(activities.saved, hasLength(1));
    expect(activities.saved.single.type, ActivityType.walking);
    expect(activities.saved.single.distanceMeters, closeTo(111.2, 0.5));
    expect(drafts.draftOf('user-1'), isNull);
    expect(find.text('Atividade recuperada e salva.'), findsOneWidget);
  });

  testWidgets('discards the interrupted activity when asked to', (
    tester,
  ) async {
    drafts.seed(_draft());

    await _pumpHome(tester, drafts: drafts, activities: activities);
    await tester.tap(find.text('Descartar'));
    await tester.pumpAndSettle();

    expect(activities.saved, isEmpty);
    expect(drafts.draftOf('user-1'), isNull);
  });

  testWidgets('silently drops a draft that has no points', (tester) async {
    drafts.seed(_draft(withPoints: false));

    await _pumpHome(tester, drafts: drafts, activities: activities);

    expect(find.text('Atividade interrompida'), findsNothing);
    expect(drafts.draftOf('user-1'), isNull);
  });

  testWidgets('keeps the draft when saving fails', (tester) async {
    drafts.seed(_draft());
    activities.shouldFail = true;

    await _pumpHome(tester, drafts: drafts, activities: activities);
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(drafts.draftOf('user-1'), isNotNull);
    expect(
      find.text('Não foi possível salvar a atividade interrompida.'),
      findsOneWidget,
    );
  });
}
