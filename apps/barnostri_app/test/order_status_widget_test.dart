import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barnostri_app/src/widgets/order_status_widget.dart';
import 'package:barnostri_app/src/core/services/language_service.dart';
import 'package:barnostri_app/l10n/generated/app_localizations.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows status text and progress indicator', (tester) async {
    final order = Order(
      id: 'o1',
      tableId: 't1',
      status: OrderStatus.preparing.displayName,
      total: 20.0,
      paymentMethod: PaymentMethod.pix.displayName,
      paid: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      items: const [],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: LanguageService.supportedLocales,
          home: OrderStatusWidget(order: order),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(OrderStatus.preparing.displayName), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
