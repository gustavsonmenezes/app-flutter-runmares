import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/history/domain/activity_details.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/history/presentation/pages/activity_details_page.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

import '../auth/fakes/fake_auth_repository.dart';
import '../recording/fakes/fake_activity_repository.dart';

TrackPoint _point(double latitude, int seconds) {
  return TrackPoint(
    latitude: latitude,
    longitude: 0,
    accuracyMeters: 5,
    timestamp: DateTime(2026).add(Duration(seconds: seconds)),
  );
}

Future<void> _pumpPage(
  WidgetTester tester,
  FakeActivityRepository repository,
  String activityId,
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
      child: MaterialApp(home: ActivityDetailsPage(activityId: activityId)),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the metrics of a saved activity', (tester) async {
    final repository = FakeActivityRepository();
    repository.details[1] = ActivityDetails(
      summary: ActivitySummary(
        id: 1,
        type: ActivityType.running,
        startedAt: DateTime(2026, 10, 3, 8),
        duration: const Duration(minutes: 32, seconds: 10),
        distanceMeters: 5230,
      ),
      segments: [
        [_point(0, 0), _point(0.001, 30)],
      ],
    );

    await _pumpPage(tester, repository, '1');

    expect(find.text('Corrida · 03/10/2026 08:00'), findsOneWidget);
    expect(find.text('5,23'), findsOneWidget);
    expect(find.text('32:10'), findsOneWidget);
    expect(find.text('6:09'), findsOneWidget);
    expect(find.text('Compartilhar Treino'), findsOneWidget);
  });

  testWidgets('shows a message for an unknown activity', (tester) async {
    await _pumpPage(tester, FakeActivityRepository(), '42');

    expect(find.text('Atividade não encontrada.'), findsOneWidget);
  });

  testWidgets('shows a message for an invalid id', (tester) async {
    await _pumpPage(tester, FakeActivityRepository(), 'abc');

    expect(find.text('Atividade não encontrada.'), findsOneWidget);
  });
}
