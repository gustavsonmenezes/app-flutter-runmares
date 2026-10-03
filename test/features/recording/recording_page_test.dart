import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/features/recording/presentation/pages/recording_page.dart';

void main() {
  testWidgets('asks for confirmation before finishing the activity', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: RecordingPage())),
    );

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
