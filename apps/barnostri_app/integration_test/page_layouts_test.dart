import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:barnostri_app/main.dart';
import 'package:barnostri_app/src/features/auth/presentation/pages/admin_page.dart';
import 'package:barnostri_app/src/features/menu/presentation/pages/menu_page.dart';
import 'package:barnostri_app/src/features/order/presentation/pages/cart_page.dart';

Future<void> _pumpApp(
  WidgetTester tester,
  Size size,
  TargetPlatform? platform,
) async {
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
  const portraitSize = Size(400, 800);
  const landscapeSize = Size(800, 400);
  const tabletSize = Size(1000, 800);

  final platforms = <String, TargetPlatform?>{
    'Android': TargetPlatform.android,
    'iOS': TargetPlatform.iOS,
    'Web': null,
  };

  platforms.forEach((name, platform) {
    group('Layouts on $name', () {
      testWidgets('AdminPage layout', (tester) async {
        addTearDown(() async => _reset(tester));

        await _pumpApp(tester, portraitSize, platform);
        appRouter.go('/admin');
        await tester.pumpAndSettle();
        expect(find.byType(AdminPage), findsOneWidget);

        await tester.binding.setSurfaceSize(landscapeSize);
        await tester.pumpAndSettle();
        expect(find.byType(AdminPage), findsOneWidget);

        await tester.binding.setSurfaceSize(tabletSize);
        await tester.pumpAndSettle();
        expect(find.byType(AdminPage), findsOneWidget);
      });

      testWidgets('MenuPage layout', (tester) async {
        addTearDown(() async => _reset(tester));

        await _pumpApp(tester, portraitSize, platform);
        appRouter.go('/menu');
        await tester.pumpAndSettle();
        expect(find.byType(MenuPage), findsOneWidget);

        await tester.binding.setSurfaceSize(landscapeSize);
        await tester.pumpAndSettle();
        expect(find.byType(MenuPage), findsOneWidget);

        await tester.binding.setSurfaceSize(tabletSize);
        await tester.pumpAndSettle();
        expect(find.byType(MenuPage), findsOneWidget);
      });

      testWidgets('CartPage layout', (tester) async {
        addTearDown(() async => _reset(tester));

        await _pumpApp(tester, portraitSize, platform);
        appRouter.go('/cart');
        await tester.pumpAndSettle();
        expect(find.byType(CartPage), findsOneWidget);

        await tester.binding.setSurfaceSize(landscapeSize);
        await tester.pumpAndSettle();
        expect(find.byType(CartPage), findsOneWidget);

        await tester.binding.setSurfaceSize(tabletSize);
        await tester.pumpAndSettle();
        expect(find.byType(CartPage), findsOneWidget);
      });
    });
  });
}
