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
      expect(service.state.categorias, isNotEmpty);
      expect(service.state.itensCardapio, isNotEmpty);
      expect(service.state.mesas, isNotEmpty);
    });
  });

  group('OrderService', () {
    test('add to cart and create order', () async {
      final pedidoRepo = SupabasePedidoRepository();
      final menuRepo = SupabaseMenuRepository();
      final service = OrderService(pedidoRepo, menuRepo);

      final mesa = Mesa(
        id: '1',
        numero: '1',
        qrToken: 'mesa_001_qr',
        ativo: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      service.setMesa(mesa);
      final item = ItemCardapio(
        id: 'i1',
        nome: 'Item',
        descricao: null,
        preco: 5.0,
        categoriaId: 'c1',
        disponivel: true,
        imagemUrl: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      service.addToCart(item, quantidade: 1);
      expect(service.state.cartItems.length, 1);
      final id = await service.createOrder(paymentMethod: PaymentMethod.pix);
      expect(id, isNotNull);
      expect(service.state.cartItems, isEmpty);
    });
  });
}
