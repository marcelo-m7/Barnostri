import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:barnostri_app/main.dart';
import 'package:barnostri_app/src/features/home/presentation/pages/home_page.dart';
import 'package:barnostri_app/src/features/order/presentation/pages/qr_scanner_page.dart';
import 'package:barnostri_app/src/features/order/presentation/pages/cart_page.dart';
import 'package:barnostri_app/src/features/menu/presentation/pages/menu_page.dart';

void main() {
  testWidgets('Navigator pushes scanner, menu and cart routes', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const ProviderScope(child: BarnostriApp()));
    expect(find.byType(HomePage), findsOneWidget);

    final router = GoRouter.of(tester.element(find.byType(HomePage)));
    router.go('/scanner');
    await tester.pumpAndSettle();
    expect(find.byType(QrScannerPage), findsOneWidget);

    router.go('/menu');
    await tester.pumpAndSettle();
    expect(find.byType(MenuPage), findsOneWidget);

    router.go('/cart');
    await tester.pumpAndSettle();
    expect(find.byType(CartPage), findsOneWidget);
  });
}
