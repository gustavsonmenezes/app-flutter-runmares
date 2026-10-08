import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/recording/data/notification_permission_service_provider.dart';
import 'package:runmares/features/recording/data/recording_draft_repository_provider.dart';
import 'package:runmares/features/recording/domain/notification_permission_service.dart';
import 'package:runmares/features/recording/presentation/controllers/recording_controller.dart';
import 'package:runmares/features/recording/presentation/pages/recording_page.dart';
import 'package:runmares/features/sync/data/remote_activity_store_provider.dart';

import '../auth/fakes/fake_auth_repository.dart';
import '../sync/fakes/fake_remote_activity_store.dart';
import 'fakes/fake_activity_repository.dart';
import 'fakes/fake_location_service.dart';
import 'fakes/fake_notification_permission_service.dart';
import 'fakes/fake_recording_draft_repository.dart';

const String _noticeText =
    'As notificações estão desativadas. A gravação continua funcionando, '
    'mas o aviso de gravação em andamento não aparece.';

Future<void> _pumpRecording(
  WidgetTester tester,
  FakeNotificationPermissionService permission,
) async {
  final auth = FakeAuthRepository(
    initialUser: const AuthUser(uid: 'user-1', email: 'ana@exemplo.com'),
  );
  addTearDown(auth.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        locationServiceProvider.overrideWithValue(const FakeLocationService()),
        activityRepositoryProvider.overrideWithValue(FakeActivityRepository()),
        recordingDraftRepositoryProvider.overrideWithValue(
          FakeRecordingDraftRepository(),
        ),
        authRepositoryProvider.overrideWithValue(auth),
        remoteActivityStoreProvider.overrideWithValue(
          FakeRemoteActivityStore(),
        ),
        notificationPermissionServiceProvider.overrideWithValue(permission),
      ],
      child: const MaterialApp(home: RecordingPage()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('asks for the permission and shows nothing when granted', (
    tester,
  ) async {
    final permission = FakeNotificationPermissionService(
      NotificationPermission.granted,
    );

    await _pumpRecording(tester, permission);

    expect(permission.requestCount, 1);
    expect(find.text(_noticeText), findsNothing);
  });

  testWidgets('warns that the recording continues when it is denied', (
    tester,
  ) async {
    final permission = FakeNotificationPermissionService(
      NotificationPermission.denied,
    );

    await _pumpRecording(tester, permission);

    expect(find.text(_noticeText), findsOneWidget);
    expect(find.text('Permitir notificações'), findsOneWidget);
  });

  testWidgets('asks again and hides the warning once it is granted', (
    tester,
  ) async {
    final permission = FakeNotificationPermissionService(
      NotificationPermission.denied,
    );
    await _pumpRecording(tester, permission);

    permission.result = NotificationPermission.granted;
    await tester.tap(find.text('Permitir notificações'));
    await tester.pumpAndSettle();

    expect(permission.requestCount, 2);
    expect(find.text(_noticeText), findsNothing);
  });

  testWidgets('offers the device settings when it is blocked', (tester) async {
    final permission = FakeNotificationPermissionService(
      NotificationPermission.permanentlyDenied,
    );
    await _pumpRecording(tester, permission);

    await tester.tap(find.text('Abrir configurações'));
    await tester.pumpAndSettle();

    expect(permission.settingsOpened, isTrue);
    expect(permission.requestCount, 1);
  });
}
