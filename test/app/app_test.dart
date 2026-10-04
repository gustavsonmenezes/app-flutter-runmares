import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/app/app.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_failure.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';
import 'package:runmares/features/history/data/activity_repository_provider.dart';
import 'package:runmares/features/recording/data/recording_draft_repository_provider.dart';
import 'package:runmares/features/sync/data/remote_activity_store_provider.dart';
import 'package:runmares/features/sync/presentation/providers/sync_providers.dart';
import '../features/auth/fakes/fake_auth_repository.dart';
import '../features/recording/fakes/fake_activity_repository.dart';
import '../features/recording/fakes/fake_recording_draft_repository.dart';
import '../features/sync/fakes/fake_remote_activity_store.dart';

Future<void> _pumpApp(
  WidgetTester tester,
  FakeAuthRepository repository,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        autoSyncProvider.overrideWith((ref) {}),
        authRepositoryProvider.overrideWithValue(repository),
        activityRepositoryProvider.overrideWithValue(FakeActivityRepository()),
        recordingDraftRepositoryProvider.overrideWithValue(
          FakeRecordingDraftRepository(),
        ),
        remoteActivityStoreProvider.overrideWithValue(
          FakeRemoteActivityStore(),
        ),
      ],
      child: const RunMaresApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _fillSignInForm(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).first, 'ana@exemplo.com');
  await tester.enterText(find.byType(TextFormField).last, 'senha123');
}

void main() {
  late FakeAuthRepository repository;

  setUp(() => repository = FakeAuthRepository());

  tearDown(() => repository.dispose());

  testWidgets('shows the sign in form when nobody is logged in', (
    tester,
  ) async {
    await _pumpApp(tester, repository);

    expect(find.text('Entrar'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('opens the main screen after signing in', (tester) async {
    await _pumpApp(tester, repository);

    await _fillSignInForm(tester);
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('validates the fields before signing in', (tester) async {
    await _pumpApp(tester, repository);

    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Informe seu e-mail.'), findsOneWidget);
    expect(find.text('Informe sua senha.'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('shows a clear message when the credentials are wrong', (
    tester,
  ) async {
    repository.failure = AuthFailure.wrongCredentials;
    await _pumpApp(tester, repository);

    await _fillSignInForm(tester);
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('E-mail ou senha incorretos.'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('skips the login when there is a saved session', (tester) async {
    repository.dispose();
    repository = FakeAuthRepository(
      initialUser: const AuthUser(uid: 'user-1', email: 'ana@exemplo.com'),
    );

    await _pumpApp(tester, repository);

    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('goes back to the login after signing out', (tester) async {
    repository.dispose();
    repository = FakeAuthRepository(
      initialUser: const AuthUser(uid: 'user-1', email: 'ana@exemplo.com'),
    );
    await _pumpApp(tester, repository);

    await repository.signOut();
    await tester.pumpAndSettle();

    expect(find.text('Entrar'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('creates an account from the sign up form', (tester) async {
    await _pumpApp(tester, repository);

    await tester.tap(find.text('Ainda não tem conta? Criar conta'));
    await tester.pumpAndSettle();
    expect(find.text('Confirmar senha'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'ana@exemplo.com');
    await tester.enterText(fields.at(1), 'senha123');
    await tester.enterText(fields.at(2), 'senha123');
    await tester.tap(find.widgetWithText(FilledButton, 'Criar conta'));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
