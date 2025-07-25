import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:barnostri_app/src/features/menu/data/repositories/supabase_menu_repository.dart';
import 'package:barnostri_app/src/features/order/data/repositories/supabase_order_repository.dart';
import 'package:barnostri_app/src/features/auth/data/repositories/supabase_profile_repository.dart';
import 'package:barnostri_app/src/features/menu/presentation/controllers/menu_service.dart';
import 'package:barnostri_app/src/features/order/presentation/controllers/order_service.dart';
import 'package:barnostri_app/src/features/auth/presentation/controllers/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService', () {
    test('login and logout flow', () async {
      final repo = SupabaseAuthRepository(null);
      final profileRepo = SupabaseProfileRepository(null);
      final loginUseCase = LoginUseCase(repo);
      final signUpUseCase = SignUpUseCase(repo);
      final service = AuthService(repo, loginUseCase, signUpUseCase, profileRepo);
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
      final container = ProviderContainer();
      final orderRepo = SupabaseOrderRepository(null);
      final menuRepo = SupabaseMenuRepository(null);
      final create = CreateOrderUseCase(orderRepo);
      final update = UpdateOrderStatusUseCase(orderRepo);
      final service = OrderService(
        container.read,
        orderRepo,
        menuRepo,
        create,
        update,
      );

      final table = TableModel(
        id: '1',
        number: '1',
        qrToken: 'mesa_001_qr',
        active: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      service.setTable(table);
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

    test('process payment success and failure', () async {
      final container = ProviderContainer();
      final orderRepo = SupabaseOrderRepository(null);
      final menuRepo = SupabaseMenuRepository(null);
      final create = CreateOrderUseCase(orderRepo);
      final update = UpdateOrderStatusUseCase(orderRepo);
      final service = OrderService(
        container.read,
        orderRepo,
        menuRepo,
        create,
        update,
      );

      final ok = await service.processPayment(
        method: PaymentMethod.pix,
        amount: 10,
      );
      expect(ok, isTrue);

      final fail = await service.processPayment(
        method: PaymentMethod.pix,
        amount: 0,
      );
      expect(fail, isFalse);
    });
  });
}
