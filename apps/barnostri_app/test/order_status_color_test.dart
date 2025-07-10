import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barnostri_app/src/features/order/presentation/controllers/order_service.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  testWidgets('getOrderStatusColor returns theme colors', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: Builder(builder: (context) {
        final received =
            OrderService.getOrderStatusColor(context, OrderStatus.received);
        final canceled =
            OrderService.getOrderStatusColor(context, OrderStatus.canceled);
        expect(received, Theme.of(context).colorScheme.primary);
        expect(canceled, Theme.of(context).colorScheme.error);
        return const SizedBox.shrink();
      }),
    ));
  });
}
