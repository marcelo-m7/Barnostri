import '../../models/order.dart';
import '../../models/cart_item.dart';

abstract class OrderRepository {
  Future<String?> createOrder({
    required String tableId,
    required List<CartItem> items,
    required double total,
    required String paymentMethod,
  });

  Future<bool> updateStatus(String orderId, String newStatus);

  Future<List<Order>> fetchOrders();

  Stream<List<Order>> watchOrders();

  Stream<Order> watchOrder(String orderId);
}
