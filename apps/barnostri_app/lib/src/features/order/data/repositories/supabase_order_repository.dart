import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/core/services/supabase_config.dart';

class SupabaseOrderRepository implements OrderRepository {
  final SupabaseClient? _client;

  SupabaseOrderRepository(this._client);
  @override
  Future<String?> createOrder({
    required String tableId,
    required List<CartItem> items,
    required double total,
    required String paymentMethod,
  }) async {
    if (_client == null) {
      if (kDebugMode) {
        print('📝 Mock order created: Table $tableId, Total: R\$ $total');
      }
      return 'mock-order-${DateTime.now().millisecondsSinceEpoch}';
    }
    try {
      final orderResponse = await _client!
          .from('orders')
          .insert({
            'table_id': tableId,
            'status': 'Recebido',
            'total': total,
            'payment_method': paymentMethod,
            'paid': false,
          })
          .select()
          .single();
      final orderId = orderResponse['id'];
      final itensData = items
          .map(
            (item) => {
              'order_id': orderId,
              'menu_item_id': item.item.id,
              'quantity': item.quantity,
              'note': item.note ?? '',
              'unit_price': item.item.price,
            },
          )
          .toList();
      await _client!.from('order_items').insert(itensData);
      return orderId;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao criar pedido: $e');
      }
      return null;
    }
  }

  @override
  Future<bool> updateStatus(String orderId, String newStatus) async {
    if (_client == null) {
      if (kDebugMode) {
        print('📊 Mock status update: $orderId -> $newStatus');
      }
      return true;
    }
    try {
      await _client!
          .from('orders')
          .update({'status': newStatus})
          .eq('id', orderId);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao atualizar status do pedido: $e');
      }
      return false;
    }
  }

  @override
  Future<List<Order>> fetchOrders() async {
    if (_client == null) {
      return [
        Order(
          id: 'mock-order-1',
          tableId: '1',
          status: 'Em preparo',
          total: 67.80,
          paymentMethod: 'Pix',
          paid: false,
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
          table: TableModel(
            id: '1',
            number: '1',
            qrToken: 'mesa_001_qr',
            active: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          items: [
            OrderItem(
              id: 'item-1',
              orderId: 'mock-order-1',
              menuItemId: '3',
              quantity: 1,
              note: 'Menos pimenta',
              unitPrice: 45.90,
              createdAt: DateTime.now(),
              menuItem: MenuItem(
                id: '3',
                name: 'Moqueca de Peixe',
                description: 'Moqueca tradicional com peixe fresco e dendê',
                price: 45.90,
                categoryId: '',
                available: true,
                imageUrl: null,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            ),
            OrderItem(
              id: 'item-2',
              orderId: 'mock-order-1',
              menuItemId: '2',
              quantity: 2,
              note: '',
              unitPrice: 12.00,
              createdAt: DateTime.now(),
              menuItem: MenuItem(
                id: '2',
                name: 'Caipirinha',
                description: 'Caipirinha tradicional com cachaça e limão',
                price: 12.00,
                categoryId: '',
                available: true,
                imageUrl: null,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            ),
          ],
        ),
      ];
    }
    try {
      final response = await _client!
          .from('orders')
          .select('*, tables(*), order_items(*, menu_items(*))')
          .order('created_at', ascending: false);
      return (response as List<dynamic>)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar pedidos: $e');
      }
      return [];
    }
  }

  @override
  Stream<List<Order>> watchOrders() {
    if (_client == null) {
      return Stream.periodic(
        const Duration(seconds: 5),
        (count) => [
          Order(
            id: 'mock-order-1',
            tableId: '1',
            status: 'Em preparo',
            total: 67.80,
            paymentMethod: 'Pix',
            paid: false,
            createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
            updatedAt: DateTime.now(),
          ),
        ],
      );
    }
    return _client!
        .from('orders')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map(
          (list) => list
              .map((e) => Order.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
  }

  @override
  Stream<Order> watchOrder(String orderId) {
    if (_client == null) {
      return Stream.periodic(
        const Duration(seconds: 5),
        (count) => Order(
          id: orderId,
          tableId: '1',
          status: 'Em preparo',
          total: 67.80,
          paymentMethod: 'Pix',
          paid: false,
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
          updatedAt: DateTime.now(),
        ),
      );
    }
    return _client!
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('id', orderId)
        .map((data) => Order.fromJson(data.first as Map<String, dynamic>));
  }
}
