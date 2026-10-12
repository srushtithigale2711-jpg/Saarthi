import 'package:flutter_test/flutter_test.dart';
import 'package:newproject/main.dart';

void main() {
  testWidgets(
    'SAARTHI app loads successfully',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SaarthiApp());

      await tester.pump();

      expect(find.byType(SaarthiApp), findsOneWidget);
    },
  );
}