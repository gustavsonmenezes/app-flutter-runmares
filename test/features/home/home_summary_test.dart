import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/home/presentation/pages/home_page.dart';
import 'package:runmares/features/recording/data/recording_draft_repository_provider.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/statistics/presentation/providers/statistics_clock_provider.dart';
import 'package:runmares/features/sync/data/remote_activity_store_provider.dart';

import '../auth/fakes/fake_auth_repository.dart';
import '../recording/fakes/fake_activity_repository.dart';
import '../recording/fakes/fake_recording_draft_repository.dart';
import '../sync/fakes/fake_remote_activity_store.dart';

ActivitySummary _activity(int id, DateTime startedAt) {
  return ActivitySummary(
    id: id,
    type: ActivityType.running,
    startedAt: startedAt,
    duration: const Duration(minutes: 30),
    distanceMeters: 5000,
  );
}

Future<void> _pumpHome(
  WidgetTester tester,
  FakeActivityRepository activities,
) async {
  final auth = FakeAuthRepository(
    initialUser: const AuthUser(uid: 'user-1', email: 'ana@exemplo.com'),
  );
  addTearDown(auth.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        activityRepositoryProvider.overrideWithValue(activities),
        recordingDraftRepositoryProvider.overrideWithValue(
          FakeRecordingDraftRepository(),
        ),
        remoteActivityStoreProvider.overrideWithValue(
          FakeRemoteActivityStore(),
        ),
        statisticsClockProvider.overrideWithValue(
          () => DateTime(2026, 10, 7, 12),
        ),
      ],
      child: const MaterialApp(home: HomePage()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('greets the user and offers to start an activity', (
    tester,
  ) async {
    await _pumpHome(tester, FakeActivityRepository());

    expect(find.text('Olá, ana'), findsOneWidget);
    expect(find.text('Iniciar atividade'), findsOneWidget);
  });

  testWidgets('shows a message when there are no activities', (tester) async {
    await _pumpHome(tester, FakeActivityRepository());

    expect(
      find.text('Você ainda não registrou nenhuma atividade.'),
      findsOneWidget,
    );
    expect(find.text('Nenhuma atividade neste período.'), findsOneWidget);
    expect(find.text('Ver histórico'), findsNothing);
  });

  testWidgets('lists only the three most recent activities', (tester) async {
    final repository = FakeActivityRepository();
    repository.summaries.addAll([
      _activity(4, DateTime(2026, 10, 6, 8)),
      _activity(3, DateTime(2026, 10, 5, 8)),
      _activity(2, DateTime(2026, 10, 4, 8)),
      _activity(1, DateTime(2026, 10, 3, 8)),
    ]);

    await _pumpHome(tester, repository);

    expect(find.text('Corrida · 06/10/2026 08:00'), findsOneWidget);
    expect(find.text('Corrida · 05/10/2026 08:00'), findsOneWidget);
    expect(find.text('Corrida · 04/10/2026 08:00'), findsOneWidget);
    expect(find.text('Corrida · 03/10/2026 08:00'), findsNothing);
    expect(find.text('Ver histórico'), findsOneWidget);
  });

  testWidgets('summarizes the current week', (tester) async {
    final repository = FakeActivityRepository();
    repository.summaries.add(_activity(1, DateTime(2026, 10, 5, 8)));

    await _pumpHome(tester, repository);

    expect(find.text('Esta semana'), findsOneWidget);
    expect(find.text('5,00'), findsOneWidget);
    expect(find.text('30:00'), findsAtLeastNWidgets(1));
  });
}
