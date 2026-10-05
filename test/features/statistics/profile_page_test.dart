import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/profile/presentation/pages/profile_page.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/statistics/presentation/providers/statistics_clock_provider.dart';

import '../auth/fakes/fake_auth_repository.dart';
import '../recording/fakes/fake_activity_repository.dart';

Future<void> _pumpProfile(
  WidgetTester tester,
  FakeActivityRepository repository,
) async {
  final auth = FakeAuthRepository(
    initialUser: const AuthUser(uid: 'user-1', email: 'ana@exemplo.com'),
  );
  addTearDown(auth.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        activityRepositoryProvider.overrideWithValue(repository),
        statisticsClockProvider.overrideWithValue(
          () => DateTime(2026, 10, 7, 12),
        ),
      ],
      child: const MaterialApp(home: ProfilePage()),
    ),
  );
  await tester.pumpAndSettle();
}

ActivitySummary _mondayRun() {
  return ActivitySummary(
    id: 1,
    type: ActivityType.running,
    startedAt: DateTime(2026, 10, 5, 8),
    duration: const Duration(minutes: 30),
    distanceMeters: 5000,
  );
}

void main() {
  testWidgets('shows a message when there are no activities', (tester) async {
    await _pumpProfile(tester, FakeActivityRepository());

    expect(find.text('Nenhuma atividade neste período.'), findsOneWidget);
  });

  testWidgets('shows the totals and the chart of the current week', (
    tester,
  ) async {
    final repository = FakeActivityRepository();
    repository.summaries.add(_mondayRun());

    await _pumpProfile(tester, repository);

    expect(find.text('5,00'), findsOneWidget);
    expect(find.text('30:00'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Seg'), findsOneWidget);
    expect(find.text('Nenhuma atividade neste período.'), findsNothing);
  });

  testWidgets('switches the chart from week to month', (tester) async {
    final repository = FakeActivityRepository();
    repository.summaries.add(_mondayRun());
    await _pumpProfile(tester, repository);

    await tester.tap(find.text('Mês'));
    await tester.pumpAndSettle();

    expect(find.text('1–7'), findsOneWidget);
    expect(find.text('Seg'), findsNothing);
  });
}
