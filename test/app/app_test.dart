import 'package:flutter_test/flutter_test.dart';
import 'package:runmares/app/app.dart';

void main() {
  testWidgets('shows the app name', (tester) async {
    await tester.pumpWidget(const RunMaresApp());

    expect(find.text('RunMares'), findsOneWidget);
  });
}
