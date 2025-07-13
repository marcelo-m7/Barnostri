import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:barnostri_app/main.dart';
import 'package:barnostri_app/src/features/auth/presentation/pages/admin_page.dart';
import 'package:barnostri_app/src/features/menu/presentation/pages/menu_page.dart';

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
  const size = Size(400, 800);

  final platforms = <String, TargetPlatform?>{
    'Android': TargetPlatform.android,
    'iOS': TargetPlatform.iOS,
    'Web': null,
  };

  platforms.forEach((name, platform) {
    group('Signup flow on $name', () {
      testWidgets('customer redirects to menu', (tester) async {
        addTearDown(() async => _reset(tester));

        await _pumpApp(tester, size, platform);
        appRouter.go('/signup');
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).at(0), 'Customer');
        await tester.enterText(find.byType(TextField).at(1), '123456');
        await tester.enterText(
            find.byType(TextField).at(2), 'cust@example.com');
        await tester.enterText(find.byType(TextField).at(3), 'secret');
        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        expect(find.byType(MenuPage), findsOneWidget);
      });

      testWidgets('merchant redirects to admin', (tester) async {
        addTearDown(() async => _reset(tester));

        await _pumpApp(tester, size, platform);
        appRouter.go('/signup');
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).at(0), 'Merchant');
        await tester.enterText(find.byType(TextField).at(1), '123456');
        await tester.enterText(
            find.byType(TextField).at(2), 'store@example.com');
        await tester.enterText(find.byType(TextField).at(3), 'secret');
        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Merchant').last);
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).at(4), 'My Store');
        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        expect(find.byType(AdminPage), findsOneWidget);
      });
    });
  });
}
