import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/recording/presentation/controllers/recording_controller.dart';
import 'package:runmares/features/recording/presentation/pages/recording_page.dart';

import 'fakes/fake_location_service.dart';

void main() {
  testWidgets('asks for confirmation before finishing the activity', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationServiceProvider.overrideWithValue(
            const FakeLocationService(),
          ),
        ],
        child: const MaterialApp(home: RecordingPage()),
      ),
    );
    expect(find.text('--:--'), findsOneWidget);

    await tester.tap(find.text('Iniciar'));
    await tester.pump();
    expect(find.text('Gravando...'), findsOneWidget);

    await tester.tap(find.text('Finalizar'));
    await tester.pumpAndSettle();
    expect(find.text('Finalizar atividade?'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Finalizar'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Atividade finalizada'), findsOneWidget);
  });
}
