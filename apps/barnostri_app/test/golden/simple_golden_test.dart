@Tags(['golden'])
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('simple golden', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Text('Hello')),
      ),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/simple.png'),
    );
  });
}
