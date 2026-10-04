import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/history/presentation/pages/history_page.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';

import '../auth/fakes/fake_auth_repository.dart';
import '../recording/fakes/fake_activity_repository.dart';

Future<void> _pumpPage(
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
        activityRepositoryProvider.overrideWithValue(repository),
        authRepositoryProvider.overrideWithValue(auth),
      ],
      child: const MaterialApp(home: HistoryPage()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows a message when there are no activities', (tester) async {
    await _pumpPage(tester, FakeActivityRepository());

    expect(
      find.text('Você ainda não registrou nenhuma atividade.'),
      findsOneWidget,
    );
  });

  testWidgets('lists the saved activities', (tester) async {
    final repository = FakeActivityRepository();
    repository.summaries.add(
      ActivitySummary(
        id: 1,
        type: ActivityType.running,
        startedAt: DateTime(2026, 10, 3, 8),
        duration: const Duration(minutes: 32, seconds: 10),
        distanceMeters: 5230,
      ),
    );

    await _pumpPage(tester, repository);

    expect(find.text('Corrida · 03/10/2026 08:00'), findsOneWidget);
    expect(find.text('5,23 km · 32:10'), findsOneWidget);
  });
}
