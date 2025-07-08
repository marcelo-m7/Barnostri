import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/features/menu/controllers/menu_service.dart';
import 'package:barnostri_app/src/features/order/controllers/order_service.dart';
import 'package:barnostri_app/src/features/auth/controllers/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService', () {
    test('login and logout flow', () async {
      final service = AuthService(SupabaseAuthRepository());
      await service.login(email: 'admin@barnostri.com', password: 'admin123');
      expect(service.state.isAuthenticated, isTrue);
      await service.logout();
      expect(service.state.isAuthenticated, isFalse);
    });
  });

  group('MenuService', () {
    test('loadAll fills data', () async {
      final service = MenuService(SupabaseMenuRepository());
      await service.loadAll();
      expect(service.state.categories, isNotEmpty);
      expect(service.state.menuItems, isNotEmpty);
      expect(service.state.tables, isNotEmpty);
    });
  });

  group('OrderService', () {
    test('add to cart and create order', () async {
      final pedidoRepo = SupabaseOrderRepository();
      final menuRepo = SupabaseMenuRepository();
      final service = OrderService(pedidoRepo, menuRepo);

      final mesa = TableModel(
        id: '1',
        number: '1',
        qrToken: 'mesa_001_qr',
        active: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      );
      service.setTable(mesa);
      final item = MenuItem(
        id: 'i1',
        name: 'Item',
        description: null,
        price: 5.0,
        categoryId: 'c1',
        available: true,
        imageUrl: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      service.addToCart(item, quantity: 1);
      expect(service.state.cartItems.length, 1);
      final id = await service.createOrder(paymentMethod: PaymentMethod.pix);
      expect(id, isNotNull);
      expect(service.state.cartItems, isEmpty);
    });
  });
}
