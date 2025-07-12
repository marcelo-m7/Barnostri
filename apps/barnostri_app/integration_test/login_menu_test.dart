import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:barnostri_app/main.dart';

Future<void> _pumpApp(
    WidgetTester tester, Size size, TargetPlatform? platform) async {
  await tester.binding.setSurfaceSize(size);
  debugDefaultTargetPlatformOverride = platform;
  await tester.pumpWidget(const ProviderScope(child: BarnostriApp()));
  await tester.pumpAndSettle();
}

Future<void> _reset(WidgetTester tester) async {
  debugDefaultTargetPlatformOverride = null;
  await tester.binding.setSurfaceSize(null);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const smallSize = Size(400, 800);
  const largeSize = Size(1200, 800);

  final platforms = <String, TargetPlatform?>{
    'Android': TargetPlatform.android,
    'iOS': TargetPlatform.iOS,
    'Web': null,
  };

  platforms.forEach((name, platform) {
    group('Login flow on $name', () {
      testWidgets('works on small and large screens', (tester) async {
        addTearDown(() async => _reset(tester));

        await _pumpApp(tester, smallSize, platform);
        appRouter.go('/admin');
        await tester.pumpAndSettle();

        expect(find.text('Barnostri Admin'), findsOneWidget);
        await tester.enterText(
            find.byType(TextField).at(0), 'admin@barnostri.com');
        await tester.enterText(find.byType(TextField).at(1), 'admin123');
        await tester.tap(find.text('Entrar'));
        await tester.pumpAndSettle();
        expect(find.text('Orders'), findsOneWidget);

        await tester.binding.setSurfaceSize(largeSize);
        await tester.pumpAndSettle();
        expect(find.text('Orders'), findsOneWidget);
      });
    });

    group('Menu navigation on $name', () {
      testWidgets('shows items on small and large screens', (tester) async {
        addTearDown(() async => _reset(tester));

        await _pumpApp(tester, smallSize, platform);
        appRouter.go('/menu');
        await tester.pumpAndSettle();
        expect(find.text('Entradas'), findsOneWidget);

        await tester.binding.setSurfaceSize(largeSize);
        await tester.pumpAndSettle();
        expect(find.text('Entradas'), findsOneWidget);
      });
    });
  });
}
