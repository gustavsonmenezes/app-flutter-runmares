import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/core/formatters/distance_unit.dart';
import 'package:runmares/core/widgets/map_style.dart';
import 'package:runmares/features/auth/data/auth_repository_provider.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';
import 'package:runmares/features/settings/presentation/pages/settings_page.dart';
import 'package:runmares/features/settings/presentation/providers/settings_providers.dart';

import '../auth/fakes/fake_auth_repository.dart';

Future<ProviderContainer> _pumpSettings(WidgetTester tester) async {
  final auth = FakeAuthRepository(
    initialUser: const AuthUser(uid: 'user-1', email: 'ana@exemplo.com'),
  );
  addTearDown(auth.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(auth)],
      child: const MaterialApp(home: SettingsPage()),
    ),
  );
  await tester.pumpAndSettle();

  return ProviderScope.containerOf(tester.element(find.byType(SettingsPage)));
}

void main() {
  testWidgets('shows the account and the current choices', (tester) async {
    await _pumpSettings(tester);

    expect(find.text('Conectado como ana@exemplo.com'), findsOneWidget);
    expect(find.text('Quilômetros'), findsOneWidget);
    expect(find.text('Milhas'), findsOneWidget);
    expect(find.text('Padrão'), findsOneWidget);
    expect(find.text('Topográfico'), findsOneWidget);
  });

  testWidgets('changes the distance unit', (tester) async {
    final container = await _pumpSettings(tester);

    await tester.tap(find.text('Milhas'));
    await tester.pumpAndSettle();

    expect(container.read(distanceUnitProvider), DistanceUnit.miles);
  });

  testWidgets('changes the map style', (tester) async {
    final container = await _pumpSettings(tester);

    await tester.tap(find.text('Topográfico'));
    await tester.pumpAndSettle();

    expect(container.read(mapStyleProvider), MapStyle.topographic);
  });
}
