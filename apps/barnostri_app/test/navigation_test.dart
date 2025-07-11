import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:barnostri_app/main.dart';
import 'package:barnostri_app/src/features/home/presentation/pages/home_page.dart';
import 'package:barnostri_app/src/features/home/presentation/pages/not_found_page.dart';
import 'package:barnostri_app/src/features/order/presentation/pages/qr_scanner_page.dart';
import 'package:barnostri_app/src/features/order/presentation/pages/cart_page.dart';

void main() {
  testWidgets('Navigator pushes scanner and cart routes', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(() => appRouter.go('/'));

    await tester.pumpWidget(const ProviderScope(child: BarnostriApp()));
    expect(find.byType(HomePage), findsOneWidget);

    final router = GoRouter.of(tester.element(find.byType(HomePage)));
    router.go('/scanner');
    await tester.pumpAndSettle();
    expect(find.byType(QrScannerPage), findsOneWidget);

    router.go('/cart');
    await tester.pumpAndSettle();
    expect(find.byType(CartPage), findsOneWidget);
  });

  testWidgets('Unknown route shows not found page', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(() => appRouter.go('/'));

    await tester.pumpWidget(const ProviderScope(child: BarnostriApp()));
    await tester.pumpAndSettle();
    appRouter.go('/');
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);

    final router = appRouter;
    router.go('/does-not-exist');
    await tester.pumpAndSettle();
    expect(find.byType(NotFoundPage), findsOneWidget);
  });
}
