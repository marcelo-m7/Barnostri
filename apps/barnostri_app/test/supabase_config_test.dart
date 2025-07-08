import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:barnostri_app/src/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:barnostri_app/src/features/menu/data/repositories/supabase_menu_repository.dart';
import 'package:barnostri_app/src/features/order/data/repositories/supabase_order_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final authRepo = SupabaseAuthRepository(null);
  final menuRepo = SupabaseMenuRepository(null);
  final orderRepo = SupabaseOrderRepository(null);

  group('Supabase repositories mock helpers', () {
    test('signIn returns mock user', () async {
      final res = await authRepo.signIn(
        email: 'admin@barnostri.com',
        password: 'admin123',
      );
      expect(res.user?.id, 'demo-admin-id');
    });

    test('signIn invalid throws', () async {
      expect(
        () => authRepo.signIn(email: 'wrong', password: 'bad'),
        throwsA(isA<AuthException>()),
      );
    });

    test('getCurrentUser returns null when not configured', () {
      expect(authRepo.getCurrentUser(), isNull);
    });

    test('getTableByQrToken returns mock table', () async {
      final table = await menuRepo.getTableByQrToken('mesa_001_qr');
      expect(table?.number, '1');
    });

    test('fetchCategories returns mock list', () async {
      final categories = await menuRepo.fetchCategories();
      expect(categories.length, greaterThanOrEqualTo(1));
    });

    test('fetchMenuItems returns mock list', () async {
      final items = await menuRepo.fetchMenuItems();
      expect(items.length, greaterThanOrEqualTo(1));
    });

    test('fetchTables returns mock list', () async {
      final tables = await menuRepo.fetchTables();
      expect(tables.length, greaterThanOrEqualTo(1));
    });

    test('createOrder returns mock id', () async {
      final item = MenuItem(
        id: 'i1',
        name: 'Item',
        description: null,
        price: 10.0,
        categoryId: 'c1',
        available: true,
        imageUrl: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final id = await orderRepo.createOrder(
        tableId: '1',
        items: [CartItem(item: item, quantity: 1)],
        total: 10.0,
        paymentMethod: 'Pix',
      );
      expect(id, isNotNull);
      expect(id!.startsWith('mock-order-'), isTrue);
    });

    test('updateStatus returns true', () async {
      final ok = await orderRepo.updateStatus('1', 'Pronto');
      expect(ok, isTrue);
    });

    test('fetchOrders returns mock data', () async {
      final orders = await orderRepo.fetchOrders();
      expect(orders.first.id, 'mock-order-1');
    });

    test('watchOrders emits list', () async {
      final stream = orderRepo.watchOrders();
      final first = await stream.first;
      expect(first, isA<List<Order>>());
    });
  });
}
