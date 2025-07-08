import 'package:flutter_test/flutter_test.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/features/auth/data/supabase_auth_repository.dart';
import 'package:barnostri_app/src/features/menu/data/supabase_menu_repository.dart';
import 'package:barnostri_app/src/features/order/data/supabase_order_repository.dart';
import 'package:barnostri_app/src/features/auth/domain/usecases/login_use_case.dart';
import 'package:barnostri_app/src/features/menu/domain/usecases/load_menu_use_case.dart';
import 'package:barnostri_app/src/features/order/domain/usecases/create_order_use_case.dart';
import 'package:barnostri_app/src/features/order/domain/usecases/update_order_status_use_case.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginUseCase', () {
    test('successful login returns user id', () async {
      final repo = SupabaseAuthRepository(null);
      final usecase = LoginUseCase(repo);
      final res = await usecase(email: 'admin@barnostri.com', password: 'admin123');
      expect(res.user?.id, 'demo-admin-id');
    });
  });

  group('LoadMenuUseCase', () {
    test('loads categories, items and tables', () async {
      final repo = SupabaseMenuRepository(null);
      final usecase = LoadMenuUseCase(repo);
      final result = await usecase();
      expect(result.categories, isNotEmpty);
      expect(result.items, isNotEmpty);
      expect(result.tables, isNotEmpty);
    });
  });

  group('Order use cases', () {
    test('create order and update status', () async {
      final pedidoRepo = SupabaseOrderRepository(null);
      final create = CreateOrderUseCase(pedidoRepo);
      final update = UpdateOrderStatusUseCase(pedidoRepo);

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

      final id = await create(
        tableId: '1',
        items: [CartItem(item: item, quantity: 1)],
        total: 10.0,
        paymentMethod: PaymentMethod.pix,
      );
      expect(id, isNotNull);

      final ok = await update(id!, OrderStatus.pronto);
      expect(ok, isTrue);
    });
  });
}
