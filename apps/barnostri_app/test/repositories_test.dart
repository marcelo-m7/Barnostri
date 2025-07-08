import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final auth = SupabaseAuthRepository();
  final menu = SupabaseMenuRepository();
  final pedidos = SupabaseOrderRepository();

  group('AuthRepository', () {
    test('valid login returns user', () async {
      final res = await auth.signIn(
        email: 'admin@barnostri.com',
        password: 'admin123',
      );
      expect(res.user?.id, 'demo-admin-id');
    });

    test('invalid login throws', () async {
      expect(
        () => auth.signIn(email: 'x', password: 'y'),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('MenuRepository', () {
    test('fetchCategories returns list', () async {
      final cats = await menu.fetchCategories();
      expect(cats, isNotEmpty);
    });

    test('fetchMenuItems returns list', () async {
      final itens = await menu.fetchMenuItems();
      expect(itens, isNotEmpty);
    });
  });

  group('OrderRepository', () {
    test('create and update order', () async {
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
      final id = await pedidos.createOrder(
        tableId: '1',
        items: [CartItem(item: item, quantity: 1)],
        total: 10.0,
        paymentMethod: 'Pix',
      );
      expect(id, isNotNull);
      final ok = await pedidos.updateStatus(id!, 'Pronto');
      expect(ok, isTrue);
    });
  });
}
