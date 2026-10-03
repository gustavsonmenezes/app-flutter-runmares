import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/app/app.dart';

void main() {
  testWidgets('navigates from login to the main screen', (tester) async {
    await tester.pumpWidget(const RunMaresApp());
    await tester.pumpAndSettle();

    expect(find.text('Entrar'), findsOneWidget);

    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
