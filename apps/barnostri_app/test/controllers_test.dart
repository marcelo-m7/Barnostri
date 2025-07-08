import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:barnostri_app/src/features/menu/data/repositories/supabase_menu_repository.dart';
import 'package:barnostri_app/src/features/order/data/repositories/supabase_order_repository.dart';
import 'package:barnostri_app/src/features/menu/presentation/controllers/menu_service.dart';
import 'package:barnostri_app/src/features/order/presentation/controllers/order_service.dart';
import 'package:barnostri_app/src/features/auth/presentation/controllers/auth_service.dart';
import 'package:barnostri_app/src/features/auth/domain/usecases/login_use_case.dart';
import 'package:barnostri_app/src/features/menu/domain/usecases/load_menu_use_case.dart';
import 'package:barnostri_app/src/features/order/domain/usecases/create_order_use_case.dart';
import 'package:barnostri_app/src/features/order/domain/usecases/update_order_status_use_case.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService', () {
    test('login and logout flow', () async {
      final repo = SupabaseAuthRepository(null);
      final loginUseCase = LoginUseCase(repo);
      final service = AuthService(repo, loginUseCase);
      await service.login(email: 'admin@barnostri.com', password: 'admin123');
      expect(service.state.isAuthenticated, isTrue);
      await service.logout();
      expect(service.state.isAuthenticated, isFalse);
    });
  });

  group('MenuService', () {
    test('loadAll fills data', () async {
      final repo = SupabaseMenuRepository(null);
      final loadUseCase = LoadMenuUseCase(repo);
      final service = MenuService(repo, loadUseCase);
      await service.loadAll();
      expect(service.state.categories, isNotEmpty);
      expect(service.state.menuItems, isNotEmpty);
      expect(service.state.tables, isNotEmpty);
    });
  });

  group('OrderService', () {
    test('add to cart and create order', () async {
      final pedidoRepo = SupabaseOrderRepository(null);
      final menuRepo = SupabaseMenuRepository(null);
      final create = CreateOrderUseCase(pedidoRepo);
      final update = UpdateOrderStatusUseCase(pedidoRepo);
      final service = OrderService(pedidoRepo, menuRepo, create, update);

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
