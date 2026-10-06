import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/history/domain/activity_summary.dart';
import 'package:runmares/features/history/presentation/pages/history_page.dart';
import 'package:runmares/features/profile/presentation/pages/profile_page.dart';
import 'package:runmares/features/recording/domain/activity_type.dart';
import 'package:runmares/features/settings/data/memory_settings_repository.dart';
import 'package:runmares/features/settings/data/settings_repository_provider.dart';
import 'package:runmares/features/settings/domain/app_settings.dart';
import 'package:runmares/features/statistics/presentation/providers/statistics_clock_provider.dart';

import '../auth/fakes/fake_auth_repository.dart';
import '../recording/fakes/fake_activity_repository.dart';

Future<void> _pumpInMiles(WidgetTester tester, Widget home) async {
  final auth = FakeAuthRepository(
    initialUser: const AuthUser(uid: 'user-1', email: 'ana@exemplo.com'),
  );
  addTearDown(auth.dispose);

  final repository = FakeActivityRepository();
  repository.summaries.add(
    ActivitySummary(
      id: 1,
      type: ActivityType.running,
      startedAt: DateTime(2026, 10, 5, 8),
      duration: const Duration(minutes: 32, seconds: 10),
      distanceMeters: 5230,
    ),
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        activityRepositoryProvider.overrideWithValue(repository),
        settingsRepositoryProvider.overrideWithValue(
          MemorySettingsRepository(
            const AppSettings(distanceUnit: DistanceUnit.miles),
          ),
        ),
        statisticsClockProvider.overrideWithValue(
          () => DateTime(2026, 10, 7, 12),
        ),
      ],
      child: MaterialApp(home: home),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the history shows the distances in miles', (tester) async {
    await _pumpInMiles(tester, const HistoryPage());

    expect(find.text('3,25 mi · 32:10'), findsOneWidget);
  });

  testWidgets('the profile shows the statistics in miles', (tester) async {
    await _pumpInMiles(tester, const ProfilePage());

    expect(find.text('Distância (mi)'), findsOneWidget);
    expect(find.text('3,25'), findsOneWidget);
  });
}
