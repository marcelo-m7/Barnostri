import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barnostri_app/src/features/order/presentation/controllers/order_service.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  test('getOrderStatusColor returns expected colors', () {
    expect(OrderService.getOrderStatusColor(OrderStatus.received), Colors.blue);
    expect(
        OrderService.getOrderStatusColor(OrderStatus.preparing), Colors.orange);
    expect(OrderService.getOrderStatusColor(OrderStatus.ready), Colors.green);
    expect(
        OrderService.getOrderStatusColor(OrderStatus.delivered), Colors.grey);
    expect(OrderService.getOrderStatusColor(OrderStatus.canceled), Colors.red);
  });
}
